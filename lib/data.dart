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
  String title;
  String path;
  String artist;
  String album;
  String lyrics;
  int trackNumber;

  Track(this.title, this.path, this.artist, this.album, this.lyrics,
      this.trackNumber) {
    id = hash(title + artist + album);
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

TrackQueue trackQueue = TrackQueue.instance;

class TrackQueue {
  List<Track> queue = [];
  int currentIndex = 0;
  static final TrackQueue instance = TrackQueue._internal();
  factory TrackQueue() {
    return instance;
  }
  TrackQueue._internal();
  int get length {
    return queue.length;
  }

  void pushFront(Track track) {
    queue.insert(currentIndex, track);
  }

  void pushNext(Track track) {
    if (queue.isNotEmpty) {
      queue.insert(currentIndex + 1, track);
    } else {
      pushFront(track);
    }
  }

  void pushLast(Track track) {
    queue.add(track);
  }

  void setCurrent(int index) {
    currentIndex = index;
  }

  void reset() {
    currentIndex = 0;
    queue = [];
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

Database database = Database.instance;
enum DatabaseState { Uninitialized, Loading, Ready }

class Database {
  static const String MUSIC_PATH = "storage/emulated/0/Music";
  static const List<String> SUPPORTED_FORMATS = [".mp3"];
  List files = [];
  List<Track> tracks = [];
  List<Artist> authors = [];
  List<Album> albums = [];
  DatabaseState state = DatabaseState.Uninitialized;
  static final Database instance = Database._internal();

  factory Database() {
    return instance;
  }
  Database._internal();

  void init(Function update) {
    state = DatabaseState.Loading;
    loadData();
    findMusic(update);
  }

  void loadData() {}

  void findMusic(Function update) async {
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
            title != null && title != "" ? title : p.basename(files[i].path),
            p.basename(files[i].path),
            artist != null && artist != "" ? artist : "Unknown",
            album != null && album != "" ? album : "Unknown",
            lyrics != null && lyrics != "" ? lyrics : "Unknown",
            trackNumber != null && trackNumber != ""
                ? int.parse(trackNumber)
                : 0));

        update();
      }
    }
    state = DatabaseState.Ready;
  }
}
