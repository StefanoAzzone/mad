import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';

class AlbumList extends StatelessWidget {
  List<Album> albums = List.generate(
      20, (index) => Album("AlbumName" + index.toString(), "Elon Musk", "ciao"));

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: List<IconButton>.generate(albums.length, (index) {
          return IconButton(
            onPressed: () {
              print(albums[index].name + "--" + albums[index].artist);
            },
            icon: Image.network(
                'https://awsimages.detik.net.id/visual/2021/04/29/infografis-terbongkar-tesla-elon-musk-miliki-miliaran-bitcoinaristya-rahadian_43.jpeg?w=450&q=90'),
          );
        }));
  }
}
