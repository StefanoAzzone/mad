import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class PlayingInfo
{
  bool playing = true;

  static final PlayingInfo instance = PlayingInfo._internal();
  factory PlayingInfo() {
    return instance;
  }
  PlayingInfo._internal();
}

PlayingInfo playingInfo = PlayingInfo.instance;

class _PlayButtonState extends State<PlayButton> {
  late StreamSubscription<PlayerState> sub;
  _PlayButtonState() {
    sub = player.audioPlayer.onPlayerStateChanged
        .listen((PlayerState s) => {
            setState(() => playingInfo.playing = s == PlayerState.PLAYING ?
                                                              true : false)}
          );
  }

  @override
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
          if (playingInfo.playing) {
            return const Icon(Icons.pause);
          }
          return const Icon(Icons.play_arrow);
        }()));
  }
}
