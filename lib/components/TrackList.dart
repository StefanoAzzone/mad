import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:path_provider/path_provider.dart';

class TrackList extends StatelessWidget {
  Function callback;
  String path = "";

  TrackList(Function this.callback);

  List<Track> tracks = Database.instance.tracks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tracks[index].name + " - " + tracks[index].artist),
            onTap: () {
              print(tracks[index].name);
              callback(tracks[index]);
            },
          );
        });
  }
}
