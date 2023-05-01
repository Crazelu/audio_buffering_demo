import 'dart:async';
import 'package:audio_buffering_demo/core/audio_playback_context_manager.dart';
import 'package:audio_buffering_demo/core/audio_service.dart';
import 'package:audio_buffering_demo/models/audio_result.dart';
import 'package:audio_buffering_demo/utils/locator.dart';
import 'package:audio_buffering_demo/utils/logger.dart';
import 'package:audio_buffering_demo/presentation/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AudioTrackPlayerWidget extends StatefulWidget {
  final String url;
  final String fileName;
  final int index;

  const AudioTrackPlayerWidget({
    Key? key,
    required this.index,
    required this.fileName,
    required this.url,
  }) : super(key: key);

  @override
  State<AudioTrackPlayerWidget> createState() => _AudioTrackPlayerWidgetState();
}

class _AudioTrackPlayerWidgetState extends State<AudioTrackPlayerWidget> {
  late final _logger = Logger(_AudioTrackPlayerWidgetState);
  late final _audioService = AudioService();
  StreamSubscription? _elapsedTimeSubscription;
  StreamSubscription? _playingStateSubscription;
  String get url => widget.url;

  bool _isPlaying = false;
  bool _isPaused = false;

  double _sliderValue = 0;
  double _maxSliderValue = 0;

  void _audioServiceListener() {
    _listenToPlaybackStream();
  }

  Future<void> _loadDuration() async {
    try {
      await _audioService.load(
        url: url,
        fileName: widget.fileName,
      );

      _listenToPlaybackStream();
    } catch (e) {
      _logger.log("_loadDuration -> $e");
    }
  }

  void _listenToPlaybackStream() {
    setState(() {
      _maxSliderValue = (_audioService.duration?.inSeconds ?? 0).toDouble() + 1;
    });
    _elapsedTimeSubscription =
        _audioService.playingElapsedTimeStream().listen((seconds) {
      setState(() {
        _sliderValue = seconds.toDouble();
      });

      if (_sliderValue == _maxSliderValue - 1) {
        _audioService.seek(0);
        _audioService.stopAudio();
        setState(() {
          _isPlaying = false;
          _isPaused = false;
        });
      }
    });
    _playingStateSubscription =
        _audioService.playingStateStream().listen((isPlaying) {
      if (isPlaying) {
        locator<AudioPlaybackContextManager>().registerPauseAudioCallback(() {
          _audioService.pauseAudio();
        });
      }
      setState(() {
        _isPlaying = isPlaying;
        _isPaused = !_isPlaying;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _audioService.reloadNotifier.addListener(_audioServiceListener);
    Future.microtask(() => _loadDuration());
  }

  @override
  void dispose() {
    _audioService.reloadNotifier.removeListener(_audioServiceListener);
    _audioService.dispose();
    _elapsedTimeSubscription?.cancel();
    _playingStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: widget.index % 2 == 0
            ? Colors.white
            : Theme.of(context).primaryColor.withOpacity(.02),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ValueListenableBuilder<AudioResult?>(
          valueListenable: _audioService.audio,
          builder: (_, audioResult, __) {
            if (audioResult == null) return const _LoadingIndicator();
            return Row(
              children: [
                CustomText(
                  text: "${widget.index} ",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF777E90),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: CustomText(
                          softWrap: true,
                          text: widget.fileName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 16,
                        child: Slider(
                          value: _sliderValue,
                          inactiveColor: const Color(0xffD9D9D9),
                          activeColor: Theme.of(context).primaryColor,
                          max: _maxSliderValue,
                          onChanged: (seconds) {
                            _audioService.seek(seconds.toInt());
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _MusicControlIcon(
                  onTap: () {
                    if (_isPaused) {
                      locator<AudioPlaybackContextManager>()
                          .onPlaybackStarted();
                      _audioService.resume();
                      _isPaused = false;
                      _isPlaying = true;
                      setState(() {});
                      return;
                    }
                    if (_isPlaying) {
                      _audioService.pauseAudio();
                    } else {
                      locator<AudioPlaybackContextManager>()
                          .onPlaybackStarted();
                      _audioService.playRemoteAudio(
                        url,
                        widget.fileName,
                      );
                    }
                  },
                  isPlaying: _isPlaying,
                ),
                const SizedBox(width: 8),
              ],
            );
          }),
    );
  }
}

class _MusicControlIcon extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  const _MusicControlIcon({
    Key? key,
    required this.onTap,
    this.isPlaying = false,
  }) : super(key: key);

  BorderSide _borderSide(BuildContext context) => BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 21,
        width: 21,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border(
            top: _borderSide(context),
            bottom: _borderSide(context),
            left: _borderSide(context),
            right: _borderSide(context),
          ),
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Theme.of(context).primaryColor,
          size: 16,
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffE6E8EC),
      highlightColor: const Color(0xffE6E8EC).withOpacity(.2),
      child: Row(
        children: const [
          _GreyContainer(
            height: 10,
            width: 70,
          ),
          SizedBox(width: 16),
          _GreyContainer(
            height: 10,
            width: 79 * 2.5,
          ),
          Spacer(),
          _GreyContainer(
            height: 20,
            width: 30,
            shape: BoxShape.circle,
          ),
        ],
      ),
    );
  }
}

class _GreyContainer extends StatelessWidget {
  final double height;
  final double width;
  final BoxShape shape;

  const _GreyContainer({
    Key? key,
    required this.height,
    required this.width,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape,
        color: const Color(0xffE6E8EC),
      ),
    );
  }
}
