import 'package:flutter/material.dart';
import 'parts/running_screen_oben.dart';
import 'parts/running_screen_unten.dart';
import 'package:provider/provider.dart';
import '../functionality/playback_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaybackModel(),
      child: const Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Oben(),
            ),
            Expanded(
              flex: 2,
              child: Unten(),
            ),
          ],
        ),
      ),
    );
  }
}
