import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class SelectTracks extends StatelessWidget {
  SelectTracks();

  List<Track> list = [];

  @override
  Widget build(BuildContext context) {
    list = database.tracks;
    return Scaffold(
        appBar: AppBar(
          title: Text("Select the tracks:"),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: TrackList((Track track) {
              //TODO: switch to callback
              trackQueue.pushLast(track);
            }),
          ),
          PlayBar(),
        ]));
  }
}
