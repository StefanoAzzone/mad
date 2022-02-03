import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class AlbumTracks extends StatefulWidget {
  Album album;
  Function updateHome;
  AlbumTracks(this.album, this.updateHome);
  @override
  State<AlbumTracks> createState() => _AlbumTracksState(album, updateHome);

}
class _AlbumTracksState extends State<AlbumTracks>{
  Album album;
  Function updateHome;
_AlbumTracksState(this.album, this.updateHome);
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
              updateHome;
              await Navigator.pushNamed(context, '/playingTrack');
              setState(() {
                
              });
              
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
    final args = ModalRoute.of(context)!.settings.arguments as AlbumTracksArguments;

    return AlbumTracks(args.album, args.updateHome);
  }
}

class AlbumTracksArguments {
  final Album album;
  final Function updateHome;

  AlbumTracksArguments(this.album, this.updateHome);
}