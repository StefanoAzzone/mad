import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:audioplayers/audioplayers.dart';

Player player = Player.instance;

class Player {
  static final Player instance = Player._internal();
  bool isPlaying = false;
  factory Player() {
    return instance;
  }
  Player._internal();
  AudioPlayer audioPlayer = AudioPlayer();

  void play() async {
    if (!isPlaying) {
      int result = await audioPlayer.play(
          Database.MUSIC_PATH + "/" + trackQueue.current().path,
          isLocal: true);
      isPlaying = true;
    } else {
      pause();
      isPlaying = false;
    }
  }

  void pause() async {
    await audioPlayer.pause();
  }
}
