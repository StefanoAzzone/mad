import 'dart:math';

import 'package:mad/components/PlayBar.dart';

import 'package:mad/data.dart';
import 'package:audioplayers/audioplayers.dart';

Player player = Player.instance;

class Player {
  Map<int, Function> callbacks = <int, Function>{};
  PlayBar? playBar;
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

  int subscribe(Function callback) {
    int token = Random().nextInt(1 << 32);
    callbacks[token] = callback;
    return token;
  }

  void unsubscribe(int token) {
    callbacks.remove(token);
  }

  void updateSubscribers() {
    callbacks.forEach((key, value) {
      value();
    });
  }

  void toggle() async {
    if (!isPlaying()) {
      play();
    } else {
      pause();
    }
  }

  void play() async {
    if (trackQueue.length > 0) {
      await audioPlayer.play(trackQueue.current().path, isLocal: true);
    }
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

  Future<bool> prev() async {
    await audioPlayer.seek(Duration.zero);
    if (isPlaying()) {
      pause();
    }
    if (trackQueue.currentIndex == 0) {
      play();
      return true;
    }
    trackQueue.prev();
    play();
    updateSubscribers();
    return true;
  }

  Future<bool> next() async {
    await audioPlayer.seek(Duration.zero);
    if (isPlaying()) {
      pause();
    }
    if (trackQueue.currentIndex == trackQueue.length - 1) {
      return true;
    }
    trackQueue.next();
    play();
    updateSubscribers();
    return true;
  }

  bool isPlaying() {
    return audioPlayer.state == PlayerState.PLAYING;
  }
}
