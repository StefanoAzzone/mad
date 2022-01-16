import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class TrackList extends StatelessWidget {
  List<Track> tracks = List.generate(
      20,
      (index) => Track("TrackName" + index.toString(), "artist", "album",
          "trackNumber" + index.toString()));

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
            },
          );
        });
  }
}
