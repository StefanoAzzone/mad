import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class AlbumList extends StatelessWidget {
  List<Album> albums = Database.instance.albums;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: List<IconButton>.generate(albums.length, (index) {
          return IconButton(
            onPressed: () {
              print(albums[index].name + "-" + albums[index].artist.name);
            },
            icon: albums[index].cover,
          );
        }));
  }
}
