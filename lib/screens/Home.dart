import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/ArtistList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/PlaylistList.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/screens/PlayingTrack.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String allArtists = "";

  void _updatePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (database.state == DatabaseState.Uninitialized) {
      database.init(_updatePage);
    }
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.music_note),
                text: "Tracks",
              ),
              Tab(
                icon: Icon(Icons.album),
                text: "Albums",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Artists",
              ),
              Tab(
                icon: Icon(Icons.playlist_play),
                text: "Playlists",
              ),
            ]),
            title: Text("MBox"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    TrackList((Track track) async {
                      //player.pause();
                      trackQueue.reset();
                      trackQueue.pushFront(track);
                      player.play();
                      await Navigator.pushNamed(context, '/playingTrack');
                      _updatePage();
                    }),
                    AlbumList(),
                    ArtistList(),
                    PlaylistList(),
                  ],
                ),
              ),
              PlayBar(),
            ],
          ),
        ));
  }
}
