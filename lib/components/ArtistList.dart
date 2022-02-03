import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/ArtistAlbums.dart';

class ArtistList extends StatelessWidget {
  List<Artist> artists = Database.instance.artists;
  Function updateHome;
  ArtistList(this.updateHome);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        int ncols = orientation == Orientation.portrait ? 3 : 5;
        return GridView.count(
            childAspectRatio: 1,
            padding: EdgeInsets.only(top: 0.0),
            crossAxisCount: ncols,
            children: List<IconButton>.generate(artists.length, (index) {
              return IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ExtractArgumentsArtistAlbums.routeName,
                      arguments:
                          ArtistAlbumsArguments(artists[index], updateHome),
                    );
                  },
                  icon: Column(
                    children: [
                      SizedBox(
                        child: artists[index].image,
                        width: size.width / ncols - 31,
                        height: size.width / ncols - 31,
                      ),
                      Text(
                        artists[index].name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ));
            }));
      },
    );
  }
}
