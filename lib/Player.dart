import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:audioplayers/audioplayers.dart';

Player player = Player.instance;

class Player {
  static final Player instance = Player._internal();
  factory Player() {
    return instance;
  }
  Player._internal() {
    audioPlayer.onPlayerCompletion.listen((event) {
      next();
    });
  }
  AudioPlayer audioPlayer = AudioPlayer();

  void toggle() async {
    if (!_isPlaying()) {
      play();
    } else {
      pause();
    }
  }

  void play() async {
    int result = await audioPlayer.play(
        trackQueue.current().path,
        isLocal: true);
  }

  void toEnd() async {
    audioPlayer.seek(Duration(seconds: await audioPlayer.getDuration()));
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void setCurrentTrackPosition(Duration position) async {
    await audioPlayer.seek(position);
  }

  void prev() async {
    if (trackQueue.currentIndex == 0) {
      await audioPlayer.seek(Duration.zero);
      if (!_isPlaying()) {
        play();
      }
    } else {
      if (_isPlaying()) {
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
      if (_isPlaying()) {
        pause();
      }
      trackQueue.currentIndex++;
      play();
    }
  }

  bool _isPlaying() {
    return audioPlayer.state == PlayerState.PLAYING;
  }
}
