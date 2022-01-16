import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

int hash(String input) {
  return md5.convert(utf8.encode(input)).hashCode;
}

class Track {
  int id = -1;
  String name;
  String artist;
  String album;
  String trackNumber;

  Track(this.name, this.artist, this.album, this.trackNumber) {
    id = hash(name + artist + album);
  }
}

class Artist {
  int id = -1;
  String name;

  Artist(this.name) {
    id = hash(name);
  }
}

class Album {
  int id = -1;
  String name;
  String artist;

  Album(this.name, this.artist) {
    id = hash(name + artist);
  }
}

class Playlist {
  int id = -1;
  String name;
  List<Track> tracks = [];

  Playlist(this.name) {
    tracks = [];
    id = hash(name);
  }
}

class Cover {
  int id;
  Image image;

  Cover(this.id, this.image);
}
