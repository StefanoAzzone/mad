import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

String durationToString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return twoDigitMinutes + ":" + twoDigitSeconds;
}

class DurationInfo
{
  Duration trackPosition = const Duration();
  Duration trackDuration = const Duration();

  static final DurationInfo instance = DurationInfo._internal();
  factory DurationInfo() {
    return instance;
  }
  DurationInfo._internal();
}

DurationInfo durationInfo = DurationInfo.instance;

class ProgressBar extends StatefulWidget {

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  bool isChanging = false;

  late StreamSubscription<Duration> pos;
  late StreamSubscription<Duration> dur;

  _ProgressBarState() {
    pos = player.audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!isChanging) {
        setState(() => durationInfo.trackPosition = p);

      }
    });
    dur = player.audioPlayer.onDurationChanged.listen((Duration d) {
      if (!isChanging) {
        setState(() => durationInfo.trackDuration = d);
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
          child: Text(durationToString(durationInfo.trackPosition)),
        ),
        Expanded(
          child: Slider(
              onChangeStart: (value) => isChanging = true,
              onChanged: (double value) {
                setState(() {
                  durationInfo.trackPosition = Duration(seconds: value.toInt());
                });
              },
              onChangeEnd: (double newValue) {
                setState(() {
                  isChanging = false;
                  player.setCurrentTrackPosition(
                      Duration(seconds: newValue.toInt()));
                });
              },
              value: durationInfo.trackPosition.inSeconds.toDouble(),
              max: durationInfo.trackDuration.inSeconds.toDouble()),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(durationToString(durationInfo.trackDuration)),
        ),
      ],
    );
  }
}
