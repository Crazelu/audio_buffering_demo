import 'dart:async';
import 'package:audio_buffering_demo/core/audio_downloader.dart';
import 'package:audio_buffering_demo/models/audio_result.dart';
import 'package:audio_buffering_demo/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  AudioService() {
    audio.addListener(_audioListener);
  }

  late AudioPlayer _player = AudioPlayer();
  late final _downloader = AudioDownloader();
  late final _logger = Logger(AudioService);

  ValueNotifier<AudioResult?> get audio => _downloader.audio;

  final ValueNotifier<DateTime> _reloadNotifier = ValueNotifier(DateTime.now());

  ///Notifies UI of changes in the [AudioPlayer] so it can
  ///resubscribe to necessary streams.
  ValueNotifier<DateTime> get reloadNotifier => _reloadNotifier;

  ///The duration of the audio
  Duration? get duration => _player.duration;

  ///Whether the [AudioPlayer] is currently playing any audio
  bool get isPlaying => _player.playing;

  ///Listener attached to [AudioResult] from [AudioDownloader].
  ///Whenever a new [AudioResult] is received (a new chunk has been downloaded),
  ///the current [AudioPlayer] is disposed and a new one is spun to continue
  ///where the current one is. An observable jank is noticed because of the
  ///simplicity of the seek logic's estimation.
  void _audioListener() async {
    try {
      bool isPlaying = _player.playing;
      if (audio.value != null) {
        // _logger.log(
        //     "Got audio update. Setting new player for ${audio.value?.file.path}");

        final newPlayer = AudioPlayer();
        await newPlayer.setFilePath(audio.value!.file.path);
        await newPlayer.load();

        //TODO: Implement better logic to seek without causing audible janks
        await newPlayer.seek(Duration(
          milliseconds: _player.position.inMilliseconds + 40,
        ));

        final oldPlayer = _player;
        _player = newPlayer;

        oldPlayer.stop();
        oldPlayer.dispose();
        _reloadNotifier.value = DateTime.now();
        if (isPlaying) _player.play();
      }
    } catch (e) {
      _logger.log("_audioListener -> $e");
    }
  }

  ///Initiate buffered downloads (if available)
  Future<void> load({
    required String url,
    required String fileName,
  }) async {
    try {
      await _downloader.load(
        url: url,
        fileName: fileName,
      );
    } catch (e) {
      _logger.log("load: $e -> $fileName");
    }
  }

  ///Plays audio file at [path]
  Future<void> playAudioFile(String path) async {
    try {
      await pauseAudio();
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      _logger.log(e);
    }
  }

  ///Plays audio file from [url] with buffering (if supported)
  Future<void> playRemoteAudio(String url, String fileName) async {
    try {
      if (audio.value != null) {
        return await playAudioFile(audio.value!.file.path);
      }
    } catch (e) {
      _logger.log(e);
    }
  }

  ///Pauses audio playback
  Future<void> pauseAudio() async {
    try {
      await _player.pause();
    } catch (e) {
      _logger.log(e);
    }
  }

  ///Resumes audio playback. This is typically called after pause.
  Future<void> resume() async {
    await _player.play();
  }

  ///Seeks to a position in the audio playback
  Future<void> seek(int seconds) async {
    try {
      await _player.seek(Duration(seconds: seconds));
    } catch (e) {
      _logger.log(e);
    }
  }

  ///Stops audio playback
  Future<void> stopAudio() async {
    try {
      await _player.stop();
    } catch (e) {
      _logger.log(e);
    }
  }

  ///Stream of how many seconds the audio has played out of its [duration]
  Stream<int> playingElapsedTimeStream() {
    return _player.positionStream.map((event) => event.inSeconds);
  }

  ///[AudioPlayer]'s playing state stream
  Stream<bool> playingStateStream() {
    return _player.playingStream;
  }

  ///Disposes resources
  void dispose() {
    audio.removeListener(_audioListener);
    stopAudio();
    _player.dispose();
  }
}
