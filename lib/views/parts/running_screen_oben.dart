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
  var dateLastUpdate = DateTime.now();
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
      dateLastUpdate = DateTime(
          dateLastUpdate.year, dateLastUpdate.month, dateLastUpdate.day);
      int? steps = await Health().getTotalStepsInInterval(dateLastUpdate, now);
      stepsLastTime = steps ?? 0;
      dateLastUpdate = DateTime(
          dateLastUpdate.year, dateLastUpdate.month, dateLastUpdate.day);
    }
  }

  // /*
  void _startStepCounter() {
    int bpm = Provider.of<PlaybackModel>(context, listen: false).bpm;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var now = DateTime.now();
      print("last update: $dateLastUpdate");
      print("now: $now");
      try {
        await Health().getTotalStepsInInterval(dateLastUpdate, now);
      } catch (e) {
        bool isPlaying =
            Provider.of<PlaybackModel>(context, listen: false).isPlaying;
        int stepFrequence =
            Provider.of<PlaybackModel>(context, listen: false).stepFrequence;
        if (isPlaying == true) {
          if (stepFrequence + 10 > bpm && stepFrequence - 10 < bpm) {
            Provider.of<PlaybackModel>(context, listen: false)
                .setNextFlowers(count);
            count++;
          }
        }
      }
      int? steps = await Health().getTotalStepsInInterval(dateLastUpdate, now);
      int sec = now.difference(dateLastUpdate).inSeconds;
      if (steps != null && steps != 0) {
        print("Steps: $steps");
        print("Seconds: $sec");
        if (sec > 180) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setStepFrequence(bpm);
          print("new bpm is set");
        } else if (sec != 0) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setStepFrequence(steps * 60 ~/ sec);
        } else {
          Provider.of<PlaybackModel>(context, listen: false)
              .setStepFrequence(bpm);
        }
        dateLastUpdate = now;
      } else {
        if (sec > 120 && sec < 180) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setStepFrequence(0);
          dateLastUpdate = now;
        }
      }
      bool isPlaying =
          Provider.of<PlaybackModel>(context, listen: false).isPlaying;
      int stepFrequence =
          Provider.of<PlaybackModel>(context, listen: false).stepFrequence;
      if (isPlaying == true) {
        if (stepFrequence + 10 > bpm && stepFrequence - 10 < bpm) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setNextFlowers(count);
          count++;
        }
      }
    });
  }
  //*/

  /*
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
    });
  }
  */

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
            'assets/images/my_image.png',
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
              'Step frequence: ${playbackModel.stepFrequence}',
              //'Steps: ${playbackModel.steps}',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ],
    );
  }
}
