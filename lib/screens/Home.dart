import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/ArtistList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/PlaylistList.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';
import 'package:mad/screens/PlayingTrack.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.indigo, Colors.lightBlue])),
                    ),
                    snap: false,
                    title: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          '  MBox',
                        )),
                        IconButton(
                            onPressed: () async {
                              var result = await Navigator.pushNamed(
                                  context, '/editMetadata');
                              if (result != null) {
                                String url = await loader.queryYouTubeUrl(loader
                                        .extractTitleFromTrack(result) +
                                    ' ' +
                                    loader.extractArtistNameFromTrack(result));
                                await launch(url);
                              }
                            },
                            icon: Icon(Icons.search))
                      ],
                    ),
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    centerTitle: true,
                    bottom: const TabBar(
                      tabs: [
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
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  TrackList((List<Track> tracks, int index) async {
                    player.pause();
                    trackQueue.reset();
                    trackQueue.pushFront(tracks[index]);
                    player.play();
                    await Navigator.pushNamed(context, '/playingTrack');
                    setState(() {});
                  }, database.tracks),
                  AlbumList(database.albums),
                  ArtistList(),
                  PlaylistList()
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
                child: SizedBox(
              child: PlayBar(),
              height: 50,
            ))));
  }
}
