import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:mad/metadata_loader.dart';
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
  Artist artist;
  Album album;
  String lyrics;
  int trackNumber;

  Track(this.title, this.path, this.artist, this.album, this.lyrics,
      this.trackNumber) {
    id = hash(title + artist.name + album.name);
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
  Image cover;

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
  Audiotagger tagger = Audiotagger();
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
    findAlbum();
  }

  void loadData() {}

  void findMusic(Function update) async {
    MetadataLoader m = MetadataLoader();
    m.initialize();
    List<FileSystemEntity> files = Directory(MUSIC_PATH).listSync();
    for (var i = 0; i < files.length; i++) {
      if (SUPPORTED_FORMATS.contains(p.extension(files[i].path))) {
        Tag? tag = await tagger.readTags(
          path: files[i].path,
        );
        String? title = null;
        String? artistName = null;
        String? albumName = null;
        String? trackNumber = null;
        String? lyrics = null;
        if (tag != null) {
          title = tag.title;
          artistName = tag.artist;
          albumName = tag.album;
          trackNumber = tag.trackNumber;
          lyrics = tag.lyrics;
        }

        Album album = Album(albumName ?? "Unknown", artistName ?? "Unknown",
            await getCover(files[i].path));
        albums.add(album);

        Artist artist = Artist(artistName ?? "Unknown");
        authors.add(artist);

        tracks.add(Track(
            title != null && title != "" ? title : p.basename(files[i].path),
            p.basename(files[i].path),
            artist,
            album,
            lyrics != null && lyrics != "" ? lyrics : "Unknown",
            trackNumber != null && trackNumber != ""
                ? int.parse(trackNumber)
                : 0));

        update();
      }
    }
    state = DatabaseState.Ready;
  }

  Future getCover(String path) async {
    final Uint8List? bytes = await tagger.readArtwork(path: path);

    return Future(() {
      return bytes != null
          ? Image.memory(bytes)
          : Image.network(
              'https://awsimages.detik.net.id/visual/2021/04/29/infografis-terbongkar-tesla-elon-musk-miliki-miliaran-bitcoinaristya-rahadian_43.jpeg?w=450&q=90');
    });
  }

  void findAlbum() {}
}
