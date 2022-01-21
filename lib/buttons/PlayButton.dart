import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlayButton extends StatefulWidget {
  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  PlayerState state = PlayerState.PLAYING;

  _PlayButtonState() {
    player.audioPlayer.onPlayerStateChanged
        .listen((PlayerState s) => {setState(() => state = s)});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          player.play();
        },
        icon: (() {
          if (state == PlayerState.PLAYING) {
            return Icon(Icons.pause);
          }
          return Icon(Icons.play_arrow);
        }()));
  }
}
