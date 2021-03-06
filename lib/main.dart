import 'package:flutter/material.dart';
import 'package:mad/screens/AlbumTracks.dart';
import 'package:mad/screens/ArtistAlbums.dart';
import 'package:mad/screens/Editor/ArtistEditor.dart';
import 'package:mad/screens/Home.dart';
import 'package:mad/screens/Info/AlbumInfo.dart';
import 'package:mad/screens/Info/ArtistInfo.dart';
import 'package:mad/screens/Editor/MetadataEditor.dart';
import 'package:mad/screens/PlayingTrack.dart';
import 'package:mad/screens/SelectTracks.dart';
import 'package:mad/screens/ShowPlaylist.dart';
import 'package:mad/screens/ShowQueue.dart';

void main() {
  //Database.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBox',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'MBox'),
        '/playingTrack': (context) => const PlayingTrack(),
        '/queue': (context) => const ShowQueue(),
        ExtractArgumentsSelectTracks.routeName: (context) =>
            const ExtractArgumentsSelectTracks(),
        '/editMetadata': (context) => const MetadataEditor(),
        ExtractArgumentsArtistEditor.routeName: (context) =>
            const ExtractArgumentsArtistEditor(),
        ExtractArgumentsAlbumTracks.routeName: (context) =>
            const ExtractArgumentsAlbumTracks(),
        ExtractArgumentsArtistAlbums.routeName: (context) =>
            const ExtractArgumentsArtistAlbums(),
        ExtractArgumentsShowPlaylist.routeName: (context) =>
            const ExtractArgumentsShowPlaylist(),
        ExtractArgumentsArtistInfo.routeName: (context) =>
            const ExtractArgumentsArtistInfo(),
        ExtractArgumentsAlbumInfo.routeName: (context) =>
            const ExtractArgumentsAlbumInfo(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
