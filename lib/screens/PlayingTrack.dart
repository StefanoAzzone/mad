import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/bar/ProgressBar.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';

class PlayingTrack extends StatelessWidget {
  PlayingTrack();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        CoverButton(),
        ProgressBar(),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  player.toEnd();
                  print("ramen");
                },
                icon: Icon(Icons.ramen_dining)),
            IconButton(
                onPressed: () => (print("prev")),
                icon: Icon(Icons.skip_previous_rounded)),
            PlayButton(),
            IconButton(
                onPressed: () => (print("next")),
                icon: Icon(Icons.skip_next_rounded)),
            IconButton(
                onPressed: () {
                  print("queue");
                  Navigator.pushNamed(context, '/queue');
                },
                icon: Icon(Icons.view_list)),
          ],
        )
      ],
    ));
  }
}
