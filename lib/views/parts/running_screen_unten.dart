import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/functionality/playback_model.dart';

class Unten extends StatefulWidget {
  const Unten({super.key});

  @override
  State<Unten> createState() => _UntenState();
}

// Ich hab hier was integriert, dass du mit playbackModel.setBpm(playbackModel.bpm + 1) -> veränder die BPM
// playbackModel.togglePlayPause() -> musik ein und ausschalten
// playbackModel.setcountmusicdata(playbackModel.countmusicdata + 1); -> veränder den Track
// verändern kannst, welche BPM spielen und ob es spielt
// Kann sein, dass du Cosumer<PlaybackModel> jedes mal mit verwenden musst, um das ganze auszuführen.

//TODO: Setze setcountmusicdata auf 1, wenn der erste Track gespielt wird

class _UntenState extends State<Unten> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<PlaybackModel>(
            builder: (context, playbackModel, child) {
              return ElevatedButton(
                onPressed: () {
                  playbackModel.setBpm(playbackModel.bpm + 1);
                  playbackModel.togglePlayPause();
                  playbackModel
                      .setcountmusicdata(playbackModel.countmusicdata + 1);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Icon(
                  playbackModel.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
