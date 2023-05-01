import 'package:audio_buffering_demo/presentation/views/audio_buffering_demo_view.dart';
import 'package:audio_buffering_demo/utils/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerDependencies();
  runApp(const AudioBufferingDemoApp());
}

class AudioBufferingDemoApp extends StatelessWidget {
  const AudioBufferingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Buffering Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
      ),
      home: const AudioBufferingDemoView(),
    );
  }
}
