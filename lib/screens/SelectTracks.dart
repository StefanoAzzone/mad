import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class SelectTracks extends StatelessWidget {
  Function callback;
  SelectTracks(this.callback);

  List<Track> list = [];

  @override
  Widget build(BuildContext context) {
    list = database.tracks;
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.indigo, Colors.lightBlue])),
          ),
          title: const Text("Select the tracks:"),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(child: TrackList(callback, list)),
          PlayBar(),
        ]));
  }
}

class ExtractArgumentsSelectTracks extends StatelessWidget {
  const ExtractArgumentsSelectTracks({Key? key}) : super(key: key);

  static const routeName = '/select';

  @override
  Widget build(BuildContext context) {
    final Function f = ModalRoute.of(context)!.settings.arguments as Function;

    return SelectTracks(f);
  }
}
