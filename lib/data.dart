import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/src/widgets/image.dart' as img;

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mad/metadata_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert'; // for the utf8.encode method
import 'dart:io';

import 'package:spotify/spotify.dart';

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

  static Track fromJson(Map<String, dynamic> json) => Track(
      //TODO: ID???
      json["title"],
      json["path"],
      database.containsArtist(json["Artist"].toString()) ??
          Database.UnknownArtist,
      database.containsAlbum(json["Album"].toString()) ?? Database.UnknownAlbum,
      json["lyrics"],
      json["trackNumber"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'path': path,
        'artist': artist.id,
        'album': album.id,
        'lyrics': lyrics,
        'trackNumber': trackNumber,
      };
}

class Artist {
  int id = -1;
  String name;
  img.Image image;

  Artist(this.name, this.image) {
    id = hash(name);
  }

  static Artist fromJson(Map<String, dynamic> json) => Artist(
      //TODO: ID???
      json["name"],
      img.Image.network(json["image"]));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': "url",
      };
}

class Album {
  int id = -1;
  String name;
  Artist artist;
  img.Image cover;

  Album(this.name, this.artist, this.cover) {
    id = hash(name + artist.name);
  }

  static Album fromJson(Map<String, dynamic> json) => Album(
      //TODO: ID???
      json["name"],
      database.containsArtist(json["Artist"].toString()) ??
          Database.UnknownArtist,
      img.Image.network(json["image"]));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'Artist': artist.id,
        'image': "url",
      };
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
final img.Image defaultImage = img.Image.network(
    'https://awsimages.detik.net.id/visual/2021/04/29/infografis-terbongkar-tesla-elon-musk-miliki-miliaran-bitcoinaristya-rahadian_43.jpeg?w=450&q=90');

class Database {
  static const String MUSIC_PATH = "storage/emulated/0/Music";
  static const List<String> SUPPORTED_FORMATS = [".mp3"];
  List files = [];
  List<Track> tracks = [];
  List<Artist> artists = [];
  List<Album> albums = [];
  Audiotagger tagger = Audiotagger();
  DatabaseState state = DatabaseState.Uninitialized;
  static final Database instance = Database._internal();
  static final Artist UnknownArtist = Artist("Unknown Artist", defaultImage);
  static final Album UnknownAlbum =
      Album("Unknown Album", UnknownArtist, defaultImage);

  factory Database() {
    return instance;
  }
  Database._internal();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tracks': tracks.map((e) => e.toJson()).toList(),
        'artists': artists.map((e) => e.toJson()).toList(),
        'albums': albums.map((e) => e.toJson()).toList(),
      };

  void fromJson(Map<String, dynamic> json) {
    tracks = ((json['tracks'] as List<dynamic>)
        .map((e) => Track.fromJson(e as Map<String, dynamic>))
        .toList());
    artists = ((json['artists'] as List<dynamic>)
        .map((e) => Artist.fromJson(e as Map<String, dynamic>))
        .toList());
    albums = ((json['albums'] as List<dynamic>)
        .map((e) => Album.fromJson(e as Map<String, dynamic>))
        .toList());
  }

  void init(Function update) {
    albums.add(UnknownAlbum);
    artists.add(UnknownArtist);
    state = DatabaseState.Loading;
    loadData();
    findMusic(update);
  }

  void loadData() {}

  void findMusic(Function update) async {
    await loader.initialize();

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

        var info = await loader.searchFirstTrack(
            title != null && title != "" ? title : p.basename(files[i].path));

        if (info == null)
          tracks.add(Track(p.basename(files[i].path), files[i].path,
              UnknownArtist, UnknownAlbum, "Unknown lyrics", 0));
        else
          tracks.add(await createTrack(info, files[i].path));

        // Album album = Album(
        //     albumName ?? "Unknown",
        //     Artist(artistName ?? "Unknown", defaultImage),
        //     await getCover(files[i].path));
        // albums.add(album);

        // Artist artist = Artist(artistName ?? "Unknown", defaultImage);
        // artists.add(artist);

        // tracks.add(Track(
        //     title != null && title != "" ? title : p.basename(files[i].path),
        //     p.basename(files[i].path),
        //     artist,
        //     album,
        //     lyrics != null && lyrics != "" ? lyrics : "Unknown",
        //     trackNumber != null && trackNumber != ""
        //         ? int.parse(trackNumber)
        //         : 0));

        update();
      }
    }
    // String json = jsonEncode(database.toJson());
    // Map<String, dynamic> map = jsonDecode(json);
    // fromJson(map);
    state = DatabaseState.Ready;
  }

  Future setNewMetadata(int index, var metadata) async {
    //TODO: delete old artist and album if not usefull
    return Future(() async {
      String path = tracks[index].path;
      tracks[index] = await createTrack(metadata, path);
    });
  }

  Future getCover(String path) async {
    final Uint8List? bytes = await tagger.readArtwork(path: path);

    return Future(() {
      return bytes != null ? img.Image.memory(bytes) : defaultImage;
    });
  }

  Future<Track> createTrack(var item, String path) async {
    Artist? artist = containsArtist(loader.extractArtistIdFromTrack(item));
    if (artist == null) {
      artist = await createArtistFromTrack(item);
      artists.add(artist);
    }

    Album? album = containsAlbum(loader.extractAlbumIdFromTrack(item));
    if (album == null) {
      album = await createAlbumFromTrack(item, artist);
      albums.add(album);
    }

    String lyrics = await loader.getLyricsFromTrack(item);

    return Track(loader.extractTitleFromTrack(item), path, artist, album,
        lyrics, loader.extractTrackNumberFromTrack(item));
  }

  Future<Album> createAlbum(var item) async {
    Artist? artist = containsArtist(loader.extractArtistIdFromAlbum(item));
    if (artist == null) {
      artist = await createArtistFromAlbum(item);
      artists.add(artist);
    }
    return Album(loader.extractAlbumTitleFromAlbum(item), artist,
        loader.extractCoverFromAlbum(item));
  }

  Future<Album> createAlbumFromTrack(var item, Artist artist) {
    return Future(() async {
      return Album(loader.extractAlbumNameFromTrack(item), artist,
          loader.extractCoverFromTrack(item));
    });
  }

  Future<Artist> createArtistFromAlbum(var item) {
    return Future(() async {
      return Artist(loader.extractArtistNameFromAlbum(item),
          await loader.getArtistImage(loader.extractArtistIdFromAlbum(item)));
    });
  }

  Future<Artist> createArtistFromTrack(var item) {
    return Future(() async {
      return Artist(loader.extractArtistNameFromTrack(item),
          await loader.getArtistImage(loader.extractArtistIdFromTrack(item)));
    });
  }

  Artist? containsArtist(String Id) {
    //TODO
    return null;
  }

  Album? containsAlbum(String Id) {
    //TODO
    return null;
  }
}
