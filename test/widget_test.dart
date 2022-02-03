// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mad/main.dart';
import 'package:mad/data.dart';

void main() {
  var Artist1 = Artist("Paolo", defaultImage);
  var Artist2 = Artist("Giovanni", defaultImage);
  var Artist3 = Artist("Marco", defaultImage);
  var Artist4 = Artist("Paolo", defaultImage);

  database.insertArtist(Artist1);
  database.insertArtist(Artist2);
  database.insertArtist(Artist3);
  database.insertArtist(Artist4);

  var Album1 = Album("Giudea", Artist1, defaultImage);
  var Album2 = Album("Galilea", Artist2, defaultImage);
  var Album3 = Album("Nazareth", Artist3, defaultImage);
  var Album4 = Album("Betlemme", Artist4, defaultImage);

  database.insertAlbum(Album1);
  database.insertAlbum(Album2);
  database.insertAlbum(Album3);
  database.insertAlbum(Album4);

  var Track1 = Track("track1", "path", Artist1, Album1, "lyrics", 0);
  var Track2 = Track("track2", "path", Artist2, Album2, "lyrics", 0);
  var Track3 = Track("track3", "path", Artist3, Album3, "lyrics", 0);
  var Track4 = Track("track4", "path", Artist4, Album4, "lyrics", 0);

  database.insertTrack(Track1);
  database.insertTrack(Track2);
  database.insertTrack(Track3);
  database.insertTrack(Track4);
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

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
  });
}
