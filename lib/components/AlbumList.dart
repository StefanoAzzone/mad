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
          childAspectRatio: 0.898,
          padding: EdgeInsets.only(top: 0.0),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          children: List<IconButton>.generate(albums.length, (index) {
            return IconButton(

              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsAlbumTracks.routeName,
                  arguments: albums[index],
                );
              },
              icon: Column(
                children: [
                  albums[index].cover,
                  Text(
                    albums[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ) 
            );
          }));

      },
    );
  }
}
