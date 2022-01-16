import 'package:flutter/material.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/ArtistList.dart';
import 'package:mad/components/PlaylistList.dart';
import 'package:mad/components/TrackList.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_manager/audio_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MBox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String allArtists = "";

  void _incrementCounter() {
    setState(() {
      getMusicFolder((String p) {
        allArtists = p;
      });
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    TrackList(),
                    AlbumList(),
                    ArtistList(),
                    PlaylistList(),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Track being played.mp3"),
                      ),
                      IconButton(
                        alignment: Alignment.bottomRight,
                        color: Colors.deepPurple,
                        onPressed: () {
                          print("I'm singing in the rain!!!");
                        },
                        icon: Icon(Icons.play_arrow),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  void getMusicFolder(Function setString) async {
    String allArtists = "";
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    // returns all artists available
    List<ArtistInfo> artists = await audioQuery.getArtists();
    artists.forEach((artist) {
      allArtists = allArtists + artist.name + ", ";
    });
    setString(allArtists);
  }
}
