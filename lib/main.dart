import 'package:audio_buffering_demo/presentation/views/audio_buffering_demo_view.dart';
import 'package:audio_buffering_demo/utils/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
      ),
      home: const AudioBufferingDemoView(),
    );
  }
}
