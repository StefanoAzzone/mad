// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/ArtistCard.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/buttons/reload_button.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/ArtistList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/PlaylistList.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';
import 'package:mad/screens/AlbumTracks.dart';
import 'package:mad/screens/ArtistAlbums.dart';
import 'package:mad/screens/Editor/ArtistEditor.dart';
import 'package:mad/screens/Editor/MetadataEditor.dart';
import 'package:mad/screens/Home.dart';
import 'package:mad/screens/Info/AlbumInfo.dart';
import 'package:mad/screens/Info/ArtistInfo.dart';
import 'package:mad/screens/PlayingTrack.dart';
import 'package:mad/screens/SelectTracks.dart';
import 'package:mad/screens/ShowPlaylist.dart';
import 'package:mad/screens/ShowQueue.dart';

void main() {
  var Artist1 = Artist("Artist1", defaultImage);
  var Artist2 = Artist("Artist2", defaultImage);
  var Artist3 = Artist("Artist3", defaultImage);
  var Artist4 = Artist("Artist4", defaultImage);

  database.insertArtist(Artist1);
  database.insertArtist(Artist2);
  database.insertArtist(Artist3);
  database.insertArtist(Artist4);

  var Album1 = Album("Album1", Artist1, defaultImage, defaultAlbumThumbnail);
  var Album2 = Album("Album2", Artist2, defaultImage, defaultAlbumThumbnail);
  var Album3 = Album("Album3", Artist3, defaultImage, defaultAlbumThumbnail);
  var Album4 = Album("Album4", Artist4, defaultImage, defaultAlbumThumbnail);

  database.insertAlbum(Album1);
  database.insertAlbum(Album2);
  database.insertAlbum(Album3);
  database.insertAlbum(Album4);

  var Track1 = Track("track1", "path", Artist1, Album1, "lyrics", 0);
  var Track2 = Track("track2", "path", Artist2, Album2, "lyrics", 0);
  var Track4 = Track("track4", "path", Artist4, Album4, "lyrics", 0);
  var Track3 = Track("track3", "path", Artist3, Album3, "lyrics", 0);

  database.insertTrack(Track1);
  database.insertTrack(Track2);
  database.insertTrack(Track3);
  database.insertTrack(Track4);

  var p1 = Playlist("p1");
  p1.addTrack(Track1);

  database.insertPlaylist(p1);

  testWidgets('lexicographical order', (WidgetTester tester) async {
    int artistid = Artist1.id;
    int albumid = Album1.id;
    int trackid = Track1.id;

    expect(database.tracks[0], Track1);

    expect(database.tracks[1], Track2);

    expect(database.tracks[2], Track3);

    expect(database.tracks[3], Track4);
  });

  testWidgets('insert/delete', (WidgetTester tester) async {
    int artistid = Artist1.id;
    int albumid = Album1.id;
    int trackid = Track1.id;

    expect(database.containsTrack(trackid), Track1);

    expect(database.containsAlbum(albumid), Album1);

    expect(database.containsArtist(artistid), Artist1);

    database.deleteTrack(Track1);

    expect(database.containsTrack(trackid), null);

    expect(database.containsAlbum(albumid), null);

    expect(database.containsArtist(artistid), null);

    expect(database.playlists.contains(p1), true);

    expect(p1.tracks.length, 0);
  });

  testWidgets('artist contains albumlist', (WidgetTester tester) async {
    expect(database.artists[0].albumList.contains(Album1), true);
  });

  testWidgets('basename', (WidgetTester tester) async {
    expect(database.baseName("storage/emulated/0/Music"), "Music");

    expect(database.baseName("storage/emulated/0/Music/Song.mp3"), "Song");
  });

  testWidgets('json', (WidgetTester tester) async {
    String expectedJson =
        '{"tracks":[{"id":1303757050,"title":"track1","path":"path","artist":703976630,"album":1446941807,"lyrics":"lyrics","trackNumber":0},{"id":1696715893,"title":"track2","path":"path","artist":1718518949,"album":461520267,"lyrics":"lyrics","trackNumber":0},{"id":1440039111,"title":"track3","path":"path","artist":1565794283,"album":972580741,"lyrics":"lyrics","trackNumber":0},{"id":438494447,"title":"track4","path":"path","artist":1076842956,"album":1572982226,"lyrics":"lyrics","trackNumber":0}],"artists":[{"id":703976630,"name":"Artist1"},{"id":1718518949,"name":"Artist2"},{"id":1565794283,"name":"Artist3"},{"id":1076842956,"name":"Artist4"}],"albums":[{"id":1446941807,"name":"Album1","Artist":703976630},{"id":461520267,"name":"Album2","Artist":1718518949},{"id":972580741,"name":"Album3","Artist":1565794283},{"id":1572982226,"name":"Album4","Artist":1076842956}],"playlists":[{"id":554179025,"name":"p1","traks":[1303757050]}]}';
    print(jsonEncode(database.toJson()));

    expect(jsonEncode(database.toJson()), expectedJson);

    Map<String, dynamic> json = jsonDecode(expectedJson);
    List<Track> tracks = [];
    for (var e in (json['tracks'] as List<dynamic>)) {
      tracks.add(Track.fromJson(e as Map<String, dynamic>));
    }

    List<Playlist> playlists = [];

    for (var e in (json['playlists'] as List<dynamic>)) {
      playlists.add(Playlist.fromJson(e as Map<String, dynamic>));
    }

    expect(database.tracks.length, tracks.length);
    for (var i = 0; i < tracks.length; i++) {
      expect(database.tracks[i].id, tracks[i].id);
      expect(database.tracks[i].album, tracks[i].album);
      expect(database.tracks[i].artist, tracks[i].artist);
      expect(database.tracks[i].lyrics, tracks[i].lyrics);
      expect(database.tracks[i].path, tracks[i].path);
      expect(database.tracks[i].title, tracks[i].title);
      expect(database.tracks[i].trackNumber, tracks[i].trackNumber);
    }

    expect(database.playlists.length, playlists.length);
    for (var i = 0; i < playlists.length; i++) {
      expect(database.playlists[i].id, playlists[i].id);
      expect(database.playlists[i].name, playlists[i].name);
      expect(database.playlists[i].tracks, playlists[i].tracks);
    }
  });

  testWidgets('trackQueue', (WidgetTester tester) async {
    trackQueue.addList(database.tracks);
    trackQueue.currentIndex = 1;

    expect(trackQueue.current(), Track2);
    trackQueue.reset();

    expect(trackQueue.current().title, "UnknownTrack");
    trackQueue.pushFront(Track3);
    trackQueue.pushLast(Track4);
    trackQueue.setCurrent(1);
    trackQueue.pushNext(Track1);

    expect(trackQueue.current(), Track4);

    expect(trackQueue.queue[0], Track3);

    expect(trackQueue.queue[2], Track1);

    trackQueue.next();

    expect(trackQueue.current(), Track1);
  });

  testWidgets('Worker', (WidgetTester tester) async {
    await tester.runAsync(() async {
      expect(Database.worker.initialized, false);
      await Database.worker.initialize();
      expect(Database.worker.initialized, true);
      var n = await Database.worker.getLocalImage("path");
      expect(n, null);
    });
  });

  testWidgets('Homepage', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const MyHomePage(title: 'Test'),
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
    });
    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
    expect(find.byIcon(Icons.album), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.playlist_play), findsOneWidget);
    expect(find.byType(ReloadButton), findsOneWidget);
    expect(find.byType(TrackList), findsOneWidget);
    expect(find.byType(PlayBar), findsOneWidget);
    expect(find.textContaining("Nothing in queue"), findsOneWidget);
    expect(find.textContaining("Shuffle"), findsOneWidget);
    expect(find.textContaining("track1"), findsOneWidget);
    expect(find.textContaining("track2"), findsOneWidget);
    expect(find.textContaining("track3"), findsOneWidget);
    expect(find.textContaining("track4"), findsOneWidget);
  });

  testWidgets('playingTrack', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const PlayingTrack(),
    });
    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.art_track), findsOneWidget);
    expect(find.byIcon(Icons.skip_previous_rounded), findsOneWidget);
    expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list), findsOneWidget);
    expect(find.byType(PlayButton), findsOneWidget);
    expect(find.byType(CoverButton), findsOneWidget);
  });

  testWidgets('SelectTracks', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => SelectTracks(() {}),
    });
    await tester.pumpWidget(widget);

    expect(find.text("Select the tracks:"), findsOneWidget);
    expect(find.byType(TrackList), findsOneWidget);
    expect(find.byType(PlayBar), findsOneWidget);
  });

  testWidgets('ShowQueue', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const ShowQueue(),
    });
    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("Queue"), findsOneWidget);
    expect(find.byType(PlayBar), findsOneWidget);
    expect(find.textContaining("Nothing in queue"), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('MetadataEditor', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const MetadataEditor(),
    });
    await tester.pumpWidget(widget);
    expect(
        find.text(
            "Cannot access server.\nTry to check your internet connection."),
        findsOneWidget);
  });

  testWidgets('AlbumTracks', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => AlbumTracks(Album1),
    });
    await tester.pumpWidget(widget);
    expect(find.textContaining("Album1"), findsOneWidget);
    expect(find.textContaining("Shuffle"), findsOneWidget);
    expect(find.textContaining("track1"), findsOneWidget);
    expect(find.byType(PlayBar), findsOneWidget);
    expect(find.textContaining("Nothing in queue"), findsOneWidget);
  });

  testWidgets('AlbumInfo', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const AlbumInfo("Album1"),
    });

    await tester.pumpWidget(widget);

    expect(find.textContaining("Cannot access server"), findsOneWidget);
  });

  testWidgets('ArtistInfo', (WidgetTester tester) async {
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => const ArtistInfo("Artist1"),
    });

    await tester.pumpWidget(widget);

    expect(find.textContaining("Cannot access server"), findsOneWidget);
  });

  testWidgets('ShowPlaylist', (WidgetTester tester) async {
    p1.addTrack(Track2);
    p1.addTrack(Track4);
    Widget widget = MaterialApp(title: 'Test', initialRoute: '/', routes: {
      '/': (context) => ShowPlaylist(p1),
    });

    await tester.pumpWidget(widget);

    expect(find.textContaining("track1"), findsOneWidget);
    expect(find.textContaining("track2"), findsOneWidget);
    expect(find.textContaining("track3"), findsNothing);
    expect(find.textContaining("track4"), findsOneWidget);
  });
}
