import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlaylistList extends StatelessWidget {
  List<Playlist> playlists = database.playlists;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(playlists[index].name),
            onTap: () {
              print(playlists[index].name);
            },
          );
        }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
      ),
    );
  }
}
