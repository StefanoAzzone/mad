import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/metadata_loader.dart';
import 'package:mad/screens/Info/AlbumInfo.dart';

class ArtistInfo extends StatelessWidget {
  String artistName;
  String albumName = "Unknown Artist";
  ArtistInfo(this.artistName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return FutureBuilder(
            future: loader.getAlbumsOfArtist(artistName),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                    body: Center(
                        child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                )));
              } else {
                return Scaffold(
                    appBar: AppBar(
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.indigo, Colors.lightBlue])),
                      ),
                      title: Text(artistName),
                      centerTitle: true,
                    ),
                    body: Column(children: [
                      Expanded(
                          child: GridView.count(
                              childAspectRatio: 0.85,
                              crossAxisCount:
                                  orientation == Orientation.portrait ? 2 : 4,
                              children: List<IconButton>.generate(
                                  loader.getItemsCount(snapshot.data), (index) {
                                return IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        ExtractArgumentsAlbumInfo.routeName,
                                        arguments: loader.getItem(
                                            snapshot.data, index),
                                      );
                                    },
                                    icon: FutureBuilder(
                                      future: loader.extractCoverFromAlbum(
                                          loader.getItem(snapshot.data, index)),
                                      builder: (context, snapshotImage) {
                                        if (!snapshotImage.hasData) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else {
                                          albumName = loader.extractAlbumTitleFromAlbum(loader.getItem(snapshot.data, index));
                                          return Card(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Image.memory(
                                                        snapshotImage.data as Uint8List),
                                                ),
                                                Text(
                                                  albumName,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 14,

                                                  ),
                                                ),
                                                Text(
                                                  artistName,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontSize: 12,

                                                  ),
                                                ),
                                              ],
                                            )

                                          );

                                        }
                                      },
                                    )
                                );
                              }))),
                      PlayBar(),
                    ]));
              }
            });
      },
    );
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
