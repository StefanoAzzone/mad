import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

class ProgressBar extends StatefulWidget {
  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  bool isChanging = false;
  Duration trackPosition = Duration();
  Duration trackDuration = Duration();

  String positionString = "";
  String durationString = "";

  late StreamSubscription<Duration> pos;
  late StreamSubscription<Duration> dur;

  _ProgressBarState() {
    pos = player.audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!isChanging) {
        //print('Current position: $p');
        setState(() => trackPosition = p);
        int t = trackPosition.inSeconds % 60;
        positionString = t < 10 ? "0" : "";
        positionString += t.toString();
        positionString =
            trackPosition.inMinutes.toString() + ":" + positionString;
      }
    });
    dur = player.audioPlayer.onDurationChanged.listen((Duration d) {
      if (!isChanging) {
        //print('Max duration: $d');
        setState(() {
          trackDuration = d;
          trackPosition = Duration.zero;
        });
        int t = trackDuration.inSeconds % 60;
        durationString = t < 10 ? "0" : "";
        durationString += t.toString();
        durationString =
            trackDuration.inMinutes.toString() + ":" + durationString;
      }
    });
  }

  @protected
  @mustCallSuper
  void dispose()
  {
    pos.cancel();
    dur.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(positionString),
        ),
        Expanded(
          child: Slider(
              onChangeStart: (value) => isChanging = true,
              onChanged: (double value) {
                setState(() {
                  trackPosition = Duration(seconds: value.toInt());
                });
              },
              onChangeEnd: (double newValue) {
                setState(() {
                  isChanging = false;
                  player.setCurrentTrackPosition(
                      Duration(seconds: newValue.toInt()));
                });
              },
              value: trackPosition.inSeconds.toDouble(),
              max: trackDuration.inSeconds.toDouble()),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(durationString),
        ),
      ],
    );
  }
}
