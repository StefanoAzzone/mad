import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class AlbumTracks extends StatefulWidget {
  final Album album;
  const AlbumTracks(this.album, {Key? key}) : super(key: key);
  @override
  State<AlbumTracks> createState() => _AlbumTracksState();
}

class _AlbumTracksState extends State<AlbumTracks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.indigo, Colors.lightBlue])),
          ),
          title: Text(widget.album.name),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: TrackList((List<Track> tracks, int index) async {
                player.pause();
                trackQueue.reset();
                trackQueue.addList(tracks);
                trackQueue.setCurrent(index);
                player.play();
                await Navigator.pushNamed(context, '/playingTrack');
                setState(() {});
              }, 
              widget.album.trackList,
              true,
            ),
          ),
        ]),
        bottomNavigationBar: const BottomAppBar(
            child: SizedBox(
          child: PlayBar(),
          height: 50,
        )));
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
