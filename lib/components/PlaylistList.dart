import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlaylistList extends StatelessWidget {
  List<Playlist> playlists = List.generate(
      20, (index) => Playlist("playlist_Tesla_" + index.toString()));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(playlists[index].name),
            onTap: () {
              print(playlists[index].name);
            },
          );
        });
  }
}
