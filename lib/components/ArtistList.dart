import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class ArtistList extends StatelessWidget {
  List<Artist> artists = Database.instance.artists;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        children: List<IconButton>.generate(artists.length, (index) {
          return IconButton(
            onPressed: () {
              print(artists[index].name);
            },
            icon: artists[index].image,
          );
        }));
  }
}
