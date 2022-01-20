import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlayButton extends StatefulWidget {
  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool isPlaying = false;

  void _update() {
    isPlaying = player.isPlaying;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          print("play");
          player.play();
          _update();
        },
        icon: (() {
          if (isPlaying) {
            return Icon(Icons.pause);
          }
          return Icon(Icons.play_arrow);
        }()));
  }
}
