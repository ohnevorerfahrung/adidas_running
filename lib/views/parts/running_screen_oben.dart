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
    _initializeHealth(true);
    _startStepCounter();
  }

  Future<void> _initializeHealth(bool beginning) async {
    // Configure the health plugin before use
    Health().configure(useHealthConnectIfAvailable: true);

    // Define the types to get
    var types = [
      HealthDataType.STEPS,
    ];
    if (beginning == true) {
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
        int? steps =
            await Health().getTotalStepsInInterval(dateLastUpdate, now);
        stepsLastTime = steps ?? 0;
        dateLastUpdate = DateTime(
            dateLastUpdate.year, dateLastUpdate.month, dateLastUpdate.day);
      }
    }
  }

  void _startStepCounter() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var now = DateTime.now();
      print("last update: $dateLastUpdate");
      print("now: $now");
      try {
        _initializeHealth(false);
        await Health().getTotalStepsInInterval(dateLastUpdate, now);
      } catch (e) {
        print(e);
      }
      int? steps = await Health().getTotalStepsInInterval(dateLastUpdate, now);
      int sec = now.difference(dateLastUpdate).inSeconds;
      print("$sec");
      if (steps != null && steps != 0) {
        int bpm = Provider.of<PlaybackModel>(context, listen: false).bpm;
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
      int bpm = Provider.of<PlaybackModel>(context, listen: false).bpm;
      print(isPlaying);
      if (isPlaying == true) {
        print("bpm is $bpm");
        print("steps is $stepFrequence");
        if (stepFrequence + 10 > bpm && stepFrequence - 10 < bpm) {
          Provider.of<PlaybackModel>(context, listen: false)
              .setNextFlowers(count);
          count++;
        }
      }
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
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            Center(
              child: Consumer<PlaybackModel>(
                builder: (context, playbackModel, child) {
                  return Text(
                    '${playbackModel.amoutFlowers}',
                    style: const TextStyle(fontSize: 24),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/rose_colorful.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
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
                          heightFactor: playbackModel.nextFlowers / 15,
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
        //Consumer<PlaybackModel>(builder: (context, playbackModel, child) {
        //  return Text(
        //    '${playbackModel.stepFrequence}',
        //    style: const TextStyle(fontSize: 24),
        //  );
        //})
      ],
    );
  }
}
