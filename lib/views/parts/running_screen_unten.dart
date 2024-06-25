import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/functionality/playback_model.dart';

class Unten extends StatefulWidget {
  const Unten({super.key});

  @override
  State<Unten> createState() => _UntenState();
}

class _UntenState extends State<Unten> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen to audio duration changes
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
        print("Audio duration: $_duration");
      });
    });

    // Listen to audio position changes
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
        print("Audio position: $_position");
      });
    });

    // Listen to completion of audio playback
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        context.read<PlaybackModel>().togglePlayPause();
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<PlaybackModel>(
            builder: (context, playbackModel, child) {
              return ElevatedButton(
                onPressed: () async {
                  playbackModel.setBpm(playbackModel.bpm + 1);
                  playbackModel.togglePlayPause();
                  playbackModel.setcountmusicdata(playbackModel.countmusicdata + 1);
                  if (playbackModel.isPlaying) {
                    await _audioPlayer.setSource(AssetSource('assets/audio/vintage-rock-drums-120-bpm.mp3'));
                    await _audioPlayer.resume();
                    print("Audio is playing");
                  } else {
                    await _audioPlayer.pause();
                    print("Audio is paused");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Icon(
                  playbackModel.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
              );
            },
          ),
          Slider(
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: (double value) async {
              final position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
              await _audioPlayer.resume();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(_position)),
                Text(formatTime(_duration - _position)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
