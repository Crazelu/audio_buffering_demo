import 'package:audio_buffering_demo/core/audio_cache.dart';
import 'package:audio_buffering_demo/core/audio_downloader.dart';
import 'package:audio_buffering_demo/core/audio_playback_context_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> registerDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<AudioCache>(() => AudioCache(sharedPrefs));
  locator.registerLazySingleton<AudioPlaybackContextManager>(
      () => AudioPlaybackContextManager());
  locator.registerLazySingleton<AudioDownloader>(() => AudioDownloader());
}
