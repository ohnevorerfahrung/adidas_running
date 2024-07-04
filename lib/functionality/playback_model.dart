import 'package:flutter/material.dart';

class PlaybackModel extends ChangeNotifier {
  bool _isPlaying = false;
  int _bpm = 120;
  int _countmusicdata = 0;
  int _steps = 0;
  int _stepFrequence = 0;
  int _amoutFlowers = 0;
  int _nextFlowers = 0;

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
  int get countmusicdata => _countmusicdata;
  int get steps => _steps;
  int get stepFrequence => _stepFrequence;
  int get amoutFlowers => _amoutFlowers;
  int get nextFlowers => _nextFlowers;

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void setBpm(int bpm) {
    print("Got changed bpm: $bpm");
    _bpm = bpm;
    notifyListeners();
  }

  void setcountmusicdata(int countmusicdata) {
    _countmusicdata = countmusicdata;
    notifyListeners();
  }

  void setSteps(int steps) {
    _steps = steps;
    notifyListeners();
  }

  void setStepFrequence(int stepFrequence) {
    _stepFrequence = stepFrequence;
    notifyListeners();
  }

  void setAmoutFlowers(int amoutFlowers) {
    _amoutFlowers = amoutFlowers;
    notifyListeners();
  }

  void setNextFlowers(int nextFlowers) {
    if (nextFlowers == 30) {
      _amoutFlowers = amoutFlowers + 1;
    }
    nextFlowers = nextFlowers % 30;
    nextFlowers = nextFlowers + 1;
    _nextFlowers = nextFlowers;
    notifyListeners();
  }
}
