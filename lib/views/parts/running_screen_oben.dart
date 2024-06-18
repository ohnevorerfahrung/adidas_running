import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/functionality/playback_model.dart';

class Oben extends StatefulWidget {
  const Oben({super.key});

  @override
  State<Oben> createState() => _UntenState();
}

class _UntenState extends State<Oben> {
  bool isPlaying = false;
  int bpt = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: <Widget>[
          Consumer<PlaybackModel>(
            builder: (context, playbackModel, child) {
              return Text(playbackModel.isPlaying ? 'Playing' : 'Paused');
            },
          ),
          Consumer<PlaybackModel>(
            builder: (context, playbackModel, child) {
              return Text('BPM: ${playbackModel.bpm}');
            },
          ),
        ],
      ),
    );
  }
}
