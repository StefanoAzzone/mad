import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';

class PlayingTrack extends StatelessWidget {
  PlayingTrack();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () {
            print("lyrics, " + trackQueue.current().title);
          },
        ),
        //Image.network("https://www.notebookcheck.it/fileadmin/_processed_/9/1/csm_GeForce_RTX_6_0de5ad89ce.jpg"),
        Slider(
            value: 0,
            onChanged: (double value) =>
                print("New value: " + value.toString()),
            max: 100),
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
