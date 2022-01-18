import 'dart:collection';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // for the utf8.encode method
import 'dart:io';

int hash(String input) {
  return md5.convert(utf8.encode(input)).hashCode;
}

class Track {
  int id = -1;
  String name;
  String artist;
  String album;
  int trackNumber;

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
  String cover;

  Album(this.name, this.artist, this.cover) {
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

class TrackQueue {
  List<Track> queue = [];
  int currentIndex = 0;
 
  void add(Track track) {
    queue.add(track);
  }
  void remove(int index) {
    queue.removeAt(index);
  }
  Track next() {
    currentIndex++;
    return queue[currentIndex];
  }
  Track current() {
    return queue[currentIndex];
  }
  trackQueue() {}
}

class Database {
  List files = [];
  List<Track> tracks = [];
  List<Artist> authors = [];
  List<Album> albums = [];
  //static Database instance = this;

  Database() {
    // if(instance != null) {
    //   //TODO: destroy me
    // }
    // else {
    //   instance = this;
    // }
  }

  void findMusic() async {
    String? path = (await getExternalStorageDirectory())?.path;
    if(path != null) {
      files = Directory(path).listSync();
    }
    print(files);
  }
}
