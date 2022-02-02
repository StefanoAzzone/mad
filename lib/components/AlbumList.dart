import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatelessWidget {
  List<Album> albums;
  AlbumList(this.albums);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      int ncols = orientation == Orientation.portrait ? 2 : 4;
      return GridView.count(
          childAspectRatio: 0.80,
          padding: EdgeInsets.only(top: 0.0),
          crossAxisCount: ncols,
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
                  SizedBox(
                    child: albums[index].cover,
                    width: size.width/ncols - 10,
                    height: size.width/ncols - 10 ,
                  ),
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
