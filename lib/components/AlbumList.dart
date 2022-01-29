import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatelessWidget {
  List<Album> albums;
  AlbumList(this.albums);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: List<IconButton>.generate(albums.length, (index) {
          return IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ExtractArgumentsAlbumTracks.routeName,
                arguments: albums[index],
              );
              print(albums[index].name + "-" + albums[index].artist.name);
            },
            icon: albums[index].cover,
          );
        }));
  }
}
