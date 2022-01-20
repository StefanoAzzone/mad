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
      isPlaying = true;
      int result = await audioPlayer.play(
          Database.MUSIC_PATH + "/" + trackQueue.current().path,
          isLocal: true);
      audioPlayer.onPlayerCompletion.listen((event) {
        next();
      });
    } else {
      isPlaying = false;
      pause();
    }
  }

  void toEnd() async {
    audioPlayer.seek(Duration(seconds: await audioPlayer.getDuration()));
  }

  void pause() async {
    await audioPlayer.pause();
    isPlaying = false;
  }

  void prev() async {
    if (trackQueue.currentIndex == 0) {
      await audioPlayer.seek(Duration.zero);
      if (!isPlaying) {
        play();
      }
    } else {
      if (isPlaying) {
        pause();
      }
      trackQueue.currentIndex--;
      play();
    }
  }

  void next() async {
    if (trackQueue.currentIndex == trackQueue.length - 1) {
      await audioPlayer.seek(Duration.zero);
      pause();
    } else {
      if (isPlaying) {
        pause();
      }
      trackQueue.currentIndex++;
      play();
    }
  }
}
