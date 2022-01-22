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
    int count = database.state == DatabaseState.Ready
        ? tracks.length
        : tracks.length + 1;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == tracks.length) {
            Size size = MediaQuery.of(context).size;
            return Center(
                child: SizedBox(
                    width: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    height: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    )));
          }
          return ListTile(
            title:
                Text(tracks[index].title + " - " + tracks[index].artist.name),
            onTap: () {
              print(tracks[index].title);
              callback(tracks[index]);
            },
          );
        });
  }
}
