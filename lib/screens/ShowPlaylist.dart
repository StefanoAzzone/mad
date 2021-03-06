import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/SwipeTrackList.dart';
import 'package:mad/data.dart';

class ShowPlaylist extends StatefulWidget {
  const ShowPlaylist(this.playlist, {Key? key}) : super(key: key);
  final Playlist playlist;
  @override
  State<ShowPlaylist> createState() => _ShowPlaylistState();
}

class _ShowPlaylistState extends State<ShowPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(widget.playlist.name)),
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/select',
                      arguments: (List<Track> tracks, index) {
                    widget.playlist.addTrack(tracks[index]);
                    database.saveAllData();
                  });
                  setState(() {});
                }),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.indigo, Colors.lightBlue])),
        ),
        centerTitle: true,
      ),
      body: SwipeTrackList((List<Track> tracks, int index) async {
        player.pause();
        trackQueue.reset();
        for (Track t in tracks) {
          trackQueue.pushLast(t);
        }
        trackQueue.setCurrent(index);
        player.play();
        await Navigator.pushNamed(context, '/playingTrack');
        setState(() {});
      }, (Track track) {
        widget.playlist.removeTrack(track);
        database.saveAllData();
      }, widget.playlist.tracks),
      bottomNavigationBar: const BottomAppBar(
          child: SizedBox(
        child: PlayBar(),
        height: 50,
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
