import 'dart:io';
import 'package:audio_buffering_demo/models/audio_result.dart';
import 'package:audio_buffering_demo/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioDownloader {
  static const String mediaDirectory = "audioCache";
  final _logger = Logger(AudioDownloader);

  late final ValueNotifier<AudioResult?> _downloadedAudio = ValueNotifier(null);

  ///A wrapper around the downloaded file that is written to
  ///when chunks are downloaded.
  ValueNotifier<AudioResult?> get audio => _downloadedAudio;

  static const int _maxChunks = 10;
  static const int _maxTriesPerChunk = 3;
  int _currentChunk = 1;
  int _bytesPerChunk = 0;
  int _totalBytes = 0;

  ///Fetch audio metadata and queue chunk downloads.
  Future<void> load({
    required String url,
    required String fileName,
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    try {
      final response = await http.head(Uri.parse(url));
      final headers = response.headers;

      _totalBytes = int.parse(headers["content-length"] ?? "0");
      _bytesPerChunk = _totalBytes ~/ _maxChunks;

      queueDownloads(
        url: url,
        fileName: fileName,
        directory: directory,
        //this header indicates whether we can fetch the file in chunks
        canBuffer: (headers["accept-ranges"] ?? "") == "bytes",
      );
    } catch (e) {
      _logger.log("load -> $e");
    }
  }

  ///Queues chunk downloads with retries if buffering is supported.
  ///Otherwise, the entire audio content is downloaded once.
  Future<void> queueDownloads({
    required String url,
    required String fileName,
    bool canBuffer = false,
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    try {
      if (!canBuffer) {
        _logger.log("Can't buffer. Downloading whole audio instead");

        await downloadWholeAudio(
          url: url,
          fileName: fileName,
          directory: directory,
        );
        return;
      }

      int tries = 0;

      while (_currentChunk <= _maxChunks && tries != _maxTriesPerChunk) {
        final bytes = await downloadChunk(
          url: url,
          fileName: fileName,
          directory: directory,
        );

        if (bytes.isNotEmpty) {
          //write to file
          final audioFile = _downloadedAudio.value?.file ??
              await _getFile(fileName, directory: directory);

          await audioFile.writeAsBytes(
            bytes,
            mode: _currentChunk == 1 ? FileMode.write : FileMode.append,
          );
          _downloadedAudio.value = AudioResult(
            file: audioFile,
            tag: DateTime.now().toIso8601String(),
          );

          _currentChunk++;
          tries = 0;
          continue;
        } else {
          tries++;
        }
      }
    } catch (e) {
      _logger.log("queueDownloads -> $e");
    }
  }

  ///Creates and returns a [File] with [fileName] in [directory].
  Future<File> _getFile(
    String fileName, {
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    String fileDirectory = "${dir.path}/$directory";

    await Directory(fileDirectory).create(recursive: true);

    return File("$fileDirectory/$fileName");
  }

  ///Downloads a chunk of audio from [url].
  Future<Uint8List> downloadChunk({
    required String url,
    required String fileName,
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    try {
      if (fileName.isEmpty) return Uint8List.fromList([]);

      int startBytes;
      if (_currentChunk == 1) {
        startBytes = 0;
      } else {
        startBytes = ((_currentChunk - 1) * _bytesPerChunk) + 1;
      }

      int endBytes = _currentChunk * _bytesPerChunk;
      if (endBytes > _totalBytes) {
        endBytes = _totalBytes;
      }

      _logger.log(
          "($fileName) -> Starting chunk download for range $startBytes-$endBytes");

      final response = await http.get(
        Uri.parse(url),
        headers: {"Range": "bytes=$startBytes-$endBytes"},
      );

      return response.bodyBytes;
    } catch (e) {
      _logger.log("downloadChunk -> $e");
    }
    return Uint8List.fromList([]);
  }

  ///Downloads the entire audio file from [url].
  Future<void> downloadWholeAudio({
    required String url,
    required String fileName,
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    try {
      if (fileName.isEmpty) return;

      final response = await http.get(Uri.parse(url));
      final fileBytes = response.bodyBytes;

      final dir = await getApplicationDocumentsDirectory();
      String fileDirectory = "${dir.path}/$directory";

      await Directory(fileDirectory).create(recursive: true);

      File downloadedFile = File("$fileDirectory/$fileName");

      if (!await downloadedFile.exists()) {
        await downloadedFile.writeAsBytes(fileBytes);
      }

      _downloadedAudio.value = AudioResult(
        file: downloadedFile,
        tag: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      _logger.log("downloadWholeAudio -> $e");
    }
  }
}
