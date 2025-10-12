// lib/features/journal/presentation/widgets/audio_player_widget.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.onDelete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _audioPlayer.setSourceDeviceFile(widget.audioPath);
    
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    final duration = await _audioPlayer.getDuration();
    if (duration != null && mounted) {
      setState(() => _duration = duration);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.resume();
      setState(() => _isPlaying = true);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                iconSize: 40,
                color: Colors.purple,
                onPressed: _togglePlayPause,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        activeColor: Colors.purple,
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await _audioPlayer.seek(position);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}