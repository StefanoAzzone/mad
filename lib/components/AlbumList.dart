import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatelessWidget {
  List<Album> albums;
  AlbumList(this.albums);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
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

      },
    );
  }
}
