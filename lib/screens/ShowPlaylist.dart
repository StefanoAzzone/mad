import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class ShowPlaylist extends StatefulWidget {
  ShowPlaylist(this.playlist, {Key? key}) : super(key: key);
  Playlist playlist;
  @override
  State<ShowPlaylist> createState() => _ShowPlaylistState(playlist);
}

class _ShowPlaylistState extends State<ShowPlaylist> {
  Playlist playlist;
  _ShowPlaylistState(this.playlist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        centerTitle: true,
      ),
      body: TrackList((Track track) async {
        player.pause();
        trackQueue.reset();
        trackQueue.pushFront(track);
        player.play();
        await Navigator.pushNamed(context, '/playingTrack');
      }, playlist.tracks),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, '/select',
                arguments: (Track track) {
              playlist.addTrack(track);
            });
            setState(() {});
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            child: PlayBar(),
            height: 70,
          )),
    );
  }
}

class ExtractArgumentsShowPlaylist extends StatelessWidget {
  const ExtractArgumentsShowPlaylist({Key? key}) : super(key: key);

  static const routeName = '/showPlaylist';

  @override
  Widget build(BuildContext context) {
    final playlist = ModalRoute.of(context)!.settings.arguments as Playlist;

    return ShowPlaylist(playlist);
  }
}
