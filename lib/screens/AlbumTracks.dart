import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class AlbumTracks extends StatelessWidget {
  Album album;
  AlbumTracks(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(album.name),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: TrackList((List<Track> tracks, int index) async {
              player.pause();
              trackQueue.reset();
              trackQueue.addList(tracks);
              trackQueue.currentIndex = index;
              player.play();
              await Navigator.pushNamed(context, '/playingTrack');
            }, album.trackList),
          ),
          PlayBar(),
        ]));
  }
}

class ExtractArgumentsAlbumTracks extends StatelessWidget {
  const ExtractArgumentsAlbumTracks({Key? key}) : super(key: key);

  static const routeName = '/albumTracks';

  @override
  Widget build(BuildContext context) {
    final album = ModalRoute.of(context)!.settings.arguments as Album;

    return AlbumTracks(album);
  }
}
