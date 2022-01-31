import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';
import 'package:mad/screens/Info/AlbumInfo.dart';

class ArtistInfo extends StatelessWidget {
  String artistName;
  ArtistInfo(this.artistName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loader.getAlbumsOfArtist(artistName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text(artistName),
                  centerTitle: true,
                ),
                body: Column(children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          children: List<IconButton>.generate(
                              loader.getItemsCount(snapshot.data), (index) {
                            return IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ExtractArgumentsAlbumInfo.routeName,
                                  arguments:
                                      loader.getItem(snapshot.data, index),
                                );
                              },
                              icon: loader.extractCoverFromAlbum(
                                  loader.getItem(snapshot.data, index)),
                            );
                          }))),
                  PlayBar(),
                ]));
          }
        });
  }
}

class ExtractArgumentsArtistInfo extends StatelessWidget {
  const ExtractArgumentsArtistInfo({Key? key}) : super(key: key);

  static const routeName = '/artistInfo';

  @override
  Widget build(BuildContext context) {
    final String artistName =
        ModalRoute.of(context)!.settings.arguments as String;

    return ArtistInfo(artistName);
  }
}
