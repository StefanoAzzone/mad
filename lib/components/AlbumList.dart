import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatefulWidget {

  List<Album> albums;
  Function updateHome;
  AlbumList(this.albums, this.updateHome);
  @override
  State<AlbumList> createState() => _AlbumListState(albums, updateHome);
}

class _AlbumListState extends State<AlbumList> {

  List<Album> albums;
  Function updateHome;

  _AlbumListState(this.albums, this.updateHome);

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

              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  ExtractArgumentsAlbumTracks.routeName,
                  arguments: AlbumTracksArguments(albums[index], updateHome),
                );
                updateHome;
                setState(() {
                  
                });
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
