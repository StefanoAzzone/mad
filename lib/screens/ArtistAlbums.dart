import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatelessWidget {
  Artist artist;
  ArtistAlbums(this.artist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(artist.name),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: AlbumList(artist.albumList),
          ),
          PlayBar(),
        ]));
  }
}

class ExtractArgumentsArtistAlbums extends StatelessWidget {
  const ExtractArgumentsArtistAlbums({Key? key}) : super(key: key);

  static const routeName = '/artistAlbums';

  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as Artist;

    return ArtistAlbums(artist);
  }
}
