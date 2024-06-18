import 'package:flutter/material.dart';

class PlaybackModel extends ChangeNotifier {
  bool _isPlaying = false;
  int _bpm = 0;
  int _countmusicdata = 0;

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
  int get countmusicdata => _countmusicdata;

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void setBpm(int bpm) {
    _bpm = bpm;
    notifyListeners();
  }

  void setcountmusicdata(int countmusicdata) {
    _countmusicdata = countmusicdata;
    notifyListeners();
  }
}
