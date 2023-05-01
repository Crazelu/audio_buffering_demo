import 'dart:convert';
import 'dart:io';
import 'package:audio_buffering_demo/core/audio_downloader.dart';
import 'package:audio_buffering_demo/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This will be used to cache audio files after they've been completely downloaded.

class AudioCache {
  static const _key = "audio_cache_key";
  final _logger = Logger(AudioCache);

  final SharedPreferences _cache;

  AudioCache(this._cache);

  Future<void> delete(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      String fileDirectory =
          "${dir.path}/${AudioDownloader.mediaDirectory}/$fileName";
      final file = File(fileDirectory);
      if (await file.exists()) {
        await file.delete();
      }
      await _cache.remove(_key);
    } catch (e) {
      _logger.log("$e");
    }
  }

  Future<void> deleteExpiredEntries(Duration maxDuration) async {
    final entries = getEntries();
    List<String> filesToDelete = [];

    final currentTimeStamp = DateTime.now();

    for (var key in entries.keys) {
      final cachePeriod = DateTime.parse(entries[key]!);
      if (currentTimeStamp.difference(cachePeriod) >= maxDuration) {
        filesToDelete.add(key);
      }
    }

    await Future.forEach<String>(
      filesToDelete,
      (fileName) async => await delete(fileName),
    ).onError((error, stackTrace) =>
        _logger.log("Batch cached item deletion error -> $error"));
  }

  Future<void> save(String fileName) async {
    try {
      final entries = getEntries();
      entries.addAll({fileName: DateTime.now().toIso8601String()});
      await _cache.setString(_key, jsonEncode(entries));
    } catch (e) {
      _logger.log(e);
    }
  }

  Map<String, String> getEntries() {
    return Map<String, String>.from(jsonDecode(_cache.getString(_key) ?? '{}'));
  }

  Future<File?> getFile({
    required String fileName,
    String directory = AudioDownloader.mediaDirectory,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileDirectory = "${dir.path}/$directory/$fileName";

      final file = File(fileDirectory);
      if (await file.exists()) return file;
    } catch (e) {
      _logger.log(e);
    }
  }
}
