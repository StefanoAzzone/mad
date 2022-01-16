import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class ArtistList extends StatelessWidget {
  List<Artist> artists =
      List.generate(20, (index) => Artist("Artist" + index.toString()));

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        children: List<IconButton>.generate(artists.length, (index) {
          return IconButton(
            onPressed: () {
              print(artists[index].name);
            },
            icon: Image.network(
                'https://images.agi.it/pictures/agi/agi/2021/12/13/152027475-4106574b-4fcd-4b62-8e33-3a71c3c7dcc2.jpg'),
          );
        }));
  }
}
