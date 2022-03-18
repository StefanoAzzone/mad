import 'dart:async';

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
  late StreamSubscription<PlayerState> sub;
  _PlayButtonState() {
    sub = player.audioPlayer.onPlayerStateChanged
        .listen((PlayerState s) => {
          if(this.mounted) // we may have a leak
            setState(() => state = s)}
          );
  }

  @protected
  @mustCallSuper
  void dispose()
  {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          player.toggle();
        },
        icon: (() {
          if (state == PlayerState.PLAYING) {
            return const Icon(Icons.pause);
          }
          return const Icon(Icons.play_arrow);
        }()));
  }
}
