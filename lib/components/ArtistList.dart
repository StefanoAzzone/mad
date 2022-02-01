import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/ArtistAlbums.dart';

class ArtistList extends StatelessWidget {
  List<Artist> artists = Database.instance.artists;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.count(
          childAspectRatio: 0.7,
          padding: EdgeInsets.only(top: 0.0),
          crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
          children: List<IconButton>.generate(artists.length, (index) {
            return IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsArtistAlbums.routeName,
                  arguments: artists[index],
                );
                print(artists[index].name);
              },
              icon: Column(
                children: [
                  artists[index].image,
                  Text(
                    artists[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
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


