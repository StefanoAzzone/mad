import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert'; // for the utf8.encode method
import 'dart:io';

int hash(String input) {
  return md5.convert(utf8.encode(input)).hashCode;
}

class Track {
  int id = -1;
  String name;
  String path;
  String artist;
  String album;
  String lyrics;
  int trackNumber;

  Track(this.name, this.path, this.artist, this.album, this.lyrics,
      this.trackNumber) {
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

Database database = Database();

class Database {
  static const String MUSIC_PATH = "storage/emulated/0/Music";
  static const List<String> SUPPORTED_FORMATS = [".mp3"];
  List files = [];
  List<Track> tracks = [];
  List<Artist> authors = [];
  List<Album> albums = [];
  static final Database instance = Database._internal();

  factory Database() {
    return instance;
  }
  Database._internal();

  Future init() async {
    return Future(() {
      findMusic();
    });
  }

  void findMusic() async {
    List<FileSystemEntity> files = Directory(MUSIC_PATH).listSync();
    for (var i = 0; i < files.length; i++) {
      if (SUPPORTED_FORMATS.contains(p.extension(files[i].path))) {
        Audiotagger tagger = Audiotagger();
        Tag? tag = await tagger.readTags(
          path: files[i].path,
        );
        String? title = null;
        String? artist = null;
        String? album = null;
        String? trackNumber = null;
        String? lyrics = null;
        if (tag != null) {
          title = tag.title;
          artist = tag.artist;
          album = tag.album;
          trackNumber = tag.trackNumber;
          lyrics = tag.lyrics;
        }
        tracks.add(Track(
            title ?? "Unknown",
            p.basename(files[i].path),
            artist ?? "Unknown",
            album ?? "Unknown",
            lyrics ?? "Unknown",
            trackNumber != null ? int.parse(trackNumber) : 0));
      }
    }
  }
}
