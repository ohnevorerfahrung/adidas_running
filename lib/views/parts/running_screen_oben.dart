import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/functionality/playback_model.dart';
import 'package:health/health.dart';
import 'dart:async';

class Oben extends StatefulWidget {
  const Oben({super.key});

  @override
  State<Oben> createState() => _ObenState();
}

class _ObenState extends State<Oben> {
  int count = 0;
  int stepsLastTime = 50;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeHealth();
    _startStepCounter();
  }

  Future<void> _initializeHealth() async {
    // Configure the health plugin before use
    Health().configure(useHealthConnectIfAvailable: true);

    // Define the types to get
    var types = [
      HealthDataType.STEPS,
    ];

    // Requesting access to the data types before reading them
    bool requested = await Health().requestAuthorization(types);

    // Handle the request result here
    if (!requested) {
      //print('Authorization not granted');
      return;
    } else {
      var now = DateTime.now();
      var midnight = DateTime(now.year, now.month, now.day);
      int? steps = await Health().getTotalStepsInInterval(midnight, now);
      stepsLastTime = steps ?? 0;
      print(stepsLastTime);
    }
  }

  void _startStepCounter() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      var now = DateTime.now();
      var midnight = DateTime(now.year, now.month, now.day);
      int? steps = await Health().getTotalStepsInInterval(midnight, now);
      if (steps != null) {
        Provider.of<PlaybackModel>(context, listen: false)
            .setSteps(steps - stepsLastTime);
      } else {
        steps = 0;
        steps = steps + 60;
      }
      bool isPlaying =
          Provider.of<PlaybackModel>(context, listen: false).isPlaying;
      int bpm = Provider.of<PlaybackModel>(context, listen: false).bpm;
      if (isPlaying == true) {
        if (steps - stepsLastTime > bpm / 60 * 30 - 10 &&
            steps - stepsLastTime < bpm / 60 * 30 + 10) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setNextFlowers(count);
          count++;
        }
      }
      stepsLastTime = steps;
      //int? steps = await Health().getTotalStepsInInterval(midnight, now);
      //if (steps != null) {
      //  Provider.of<PlaybackModel>(context, listen: false).setSteps(steps);
      //}
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Expanded(flex: 2, child: SizedBox()),
        ClipOval(
          child: Image.asset(
            'assets/images/my_image.png', // Make sure you put your image in the assets directory and mention it in pubspec.yaml
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        const Expanded(flex: 2, child: SizedBox()),
        Consumer<PlaybackModel>(
          builder: (context, playbackModel, child) {
            return SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/rose_black_qnd_white.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      const Expanded(child: SizedBox()),
                      ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: playbackModel.nextFlowers / 5,
                          child: Image.asset(
                            'assets/images/rose_colorful.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const Expanded(flex: 2, child: SizedBox()),
        Consumer<PlaybackModel>(
          builder: (context, playbackModel, child) {
            return Text(
              'Steps: ${playbackModel.steps}',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ],
    );
  }
}
