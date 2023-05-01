import 'package:flutter/material.dart';
import 'package:audio_buffering_demo/models/song.dart';
import 'package:audio_buffering_demo/presentation/widgets/audio_track_player_widget.dart';

class AudioBufferingDemoView extends StatefulWidget {
  const AudioBufferingDemoView({super.key});

  @override
  State<AudioBufferingDemoView> createState() => _AudioBufferingDemoViewState();
}

class _AudioBufferingDemoViewState extends State<AudioBufferingDemoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Buffering Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < Song.songs.length; i++)
              AudioTrackPlayerWidget(
                index: i,
                url: Song.songs[i].url,
                fileName: Song.songs[i].filename,
              ),
          ],
        ),
      ),
    );
  }
}
