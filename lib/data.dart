import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/src/widgets/image.dart' as img;

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:crypto/crypto.dart';
import 'package:mad/metadata_loader.dart';
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
    album.addTrack(this);
  }

  static Track fromJson(Map<String, dynamic> json) => Track(
      //TODO: ID???
      json["title"],
      json["path"],
      database.containsArtist(json["Artist"]) ??
          Database.UnknownArtist,
      database.containsAlbum(json["Album"]) ?? Database.UnknownAlbum,
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

  void delete() {
    album.deleteTrack(this);
    database.tracks.remove(this);
  }
}

class Artist {
  List<Album> albumList = [];
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

  void addAlbum(Album album) {
    albumList.add(album);
  }

  void deleteAlbum(Album album) {
    albumList.remove(album);
    if (albumList.isEmpty) {
      database.deleteArtist(this);
    }
  }
}

class Album {
  List<Track> trackList = [];
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
      database.containsArtist(json["Artist"]) ??
          Database.UnknownArtist,
      img.Image.network(json["image"]));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'Artist': artist.id,
        'image': "url",
      };

  void addTrack(Track track) {
    trackList.add(track);
  }

  void deleteTrack(Track track) {
    if (trackList.remove(track) && trackList.isEmpty)
      database.deleteAlbum(this);
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

  void addTrack(Track track) {
    tracks.add(track);
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
final img.Image defaultImage = img.Image.asset('images/DefaultImage.png');

final img.Image defaultAlbumThumbnail =
    img.Image.asset('images/albumThumb.png');

class Database {
  static const String MUSIC_PATH = "storage/emulated/0/Music";
  static const List<String> SUPPORTED_FORMATS = [".mp3"];
  List files = [];
  List<Track> tracks = [];
  List<Artist> artists = [];
  List<Album> albums = [];
  List<Playlist> playlists = [];
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
    insertAlbum(UnknownAlbum);
    insertArtist(UnknownArtist);
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
        String? title = tag?.title;

        var info = await loader.searchFirstTrack(
            title != null && title != "" ? title : p.basename(files[i].path));

        if (info == null) {
          //cannot find info: try to use tags
          String title = tag?.title ?? "";
          String artistName = tag?.artist ?? "";
          Artist artist = artistName != ""
              ? Artist(artistName, defaultImage)
              : UnknownArtist;
          String albumName = tag?.album ?? "";
          Album album = albumName != ""
              ? Album(albumName, artist, defaultImage)
              : UnknownAlbum;
          String lyrics = tag?.lyrics ?? "";
          String trackNumber = tag?.trackNumber ?? "";
          insertTrack(Track(
              title != "" ? title : p.basename(files[i].path),
              files[i].path,
              artist,
              album,
              lyrics != "" ? lyrics : "Unknown lyrics",
              trackNumber != "" ? int.parse(trackNumber) : 0));
          print(title + " not found; generated using tags, if possible.");
        } else {
          //info found
          insertTrack(await createTrack(info, tag, files[i].path));
        }

        update();
      }
    }
    // String json = jsonEncode(database.toJson());
    // Map<String, dynamic> map = jsonDecode(json);
    // fromJson(map);
    state = DatabaseState.Ready;
  }

  Future setNewMetadata(Track track, var metadata) async {
    //TODO: delete old artist and album if not useful
    return Future(() async {
      String path = track.path;
      track.delete();
      insertTrack(await createTrack(metadata, null, path));
    });
  }

  Future getCover(String path) async {
    final Uint8List? bytes = await tagger.readArtwork(path: path);

    return Future(() {
      return bytes != null ? img.Image.memory(bytes) : defaultImage;
    });
  }

  Future<Track> createTrack(var item, Tag? tag, String path) async {
    String? title = null;
    String? artistName = null;
    String? albumName = null;
    int? trackNumber = null;
    String? lyrics = null;
    
    if (tag != null) {
      title = tag.title;
      artistName = tag.artist;
      albumName = tag.album;
      trackNumber = int.parse(tag.trackNumber ?? "-1");
      lyrics = tag.lyrics;
    }

    print(path + " found:");

    Artist artist;
    Artist? tmpArtist;
    if (artistName == "" || artistName == null) {
      //tag missing
      tmpArtist = containsArtist(hash(loader.extractArtistNameFromTrack(item)));
      if (tmpArtist == null) {
        artist = await createArtistFromTrack(item);
        insertArtist(artist);
      } else {
        artist = tmpArtist;
      }
      //await tagger.writeTag(path: path, tagField: "artist", value: artist.name);
      print("artist " + artist.name + " not in tags; used API instead");
    } else {
      //tag present
      var item = await loader.searchArtist(artistName);
      
      artist = (item == null)
          ? Artist(artistName, defaultImage) //Artist not found
          : Artist(
              loader.extractArtistNameFromArtist(item), //Artist found
              await loader.getArtistImage(loader.extractId(item)));
      //TODO : fix the id: we are not using the right id
      tmpArtist = containsArtist(artist.id);
      if (tmpArtist == null) {
        insertArtist(artist);
      } else {
        artist = tmpArtist;
      }
    }

    Album album;
    Album? tmpAlbum;
    if (albumName == "" || albumName == null) {
      //tag missing
      tmpAlbum = containsAlbum(hash(loader.extractAlbumNameFromTrack(item)
         + loader.extractArtistNameFromTrack(item)));
      if (tmpAlbum == null) {
        album = await createAlbumFromTrack(item, artist);
        albums.add(album);
      } else {
        album = tmpAlbum;
      }
      //await tagger.writeTag(path: path, tagField: "album", value: album.name);
      print("album " + album.name + " not in tags; used API instead");
    } else {
      //tag present
      
      var item = await loader.searchAlbum(albumName);
      album = (item == null)
          ? Album(albumName, artist, defaultImage) //Album not found
          : Album(loader.extractAlbumTitleFromAlbum(item), artist,
              loader.extractCoverFromAlbum(item)); //Album found
      tmpAlbum = containsAlbum(album.id);
      if (tmpAlbum == null) {
        albums.add(album);
        album.artist.addAlbum(album);
      } else {
        album = tmpAlbum;
      }
    }

    if (title == null || title == "") {
      title = loader.extractTitleFromTrack(item);
      //await tagger.writeTag(path: path, tagField: "title", value: title);
      print("title " + title + " not in tags; used API instead");
    }
    if (lyrics == null || lyrics == "") {
      lyrics = await loader.getLyricsFromTrack(item);
      //await tagger.writeTag(path: path, tagField: "lyrics", value: lyrics);
      print("lyrics not in tags; used API instead");
    }
    if (trackNumber == null || trackNumber == -1) {
      trackNumber = loader.extractTrackNumberFromTrack(item);
      //await tagger.writeTag(path: path, tagField: "trackNumber", value: trackNumber.toString());
      print("trackNumber " +
          trackNumber.toString() +
          " not in tags; used API instead");
    }

    return Track(title, path, artist, album, lyrics, trackNumber);
  }

  Future<Album> createAlbum(var item) async {
    Artist? artist = containsArtist(hash(loader.extractArtistNameFromAlbum(item)));
    if (artist == null) {
      artist = await createArtistFromAlbum(item);
      insertArtist(artist);
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

  Artist? containsArtist(int Id) {
    for(int i = 0; i < artists.length; i++) {
      if (artists[i].id == Id) 
        return artists[i];
    }
    return null;
  }

  Album? containsAlbum(int Id) {
    for(int i = 0; i < albums.length; i++) {
      if (albums[i].id == Id) 
        return albums[i];
    }
    return null;
  }

  void deleteAlbum(Album album) {
    albums.remove(album);
  }

  void deleteArtist(Artist artist) {
    artists.remove(artist);
  }

  void insertTrack(Track track) {
    for (int i = 0; i < tracks.length; i++) {
      if (track.title.compareTo(tracks[i].title) < 0) {
        tracks.insert(i, track);
        return;
      }
    }
    tracks.add(track);
  }

  void insertAlbum(Album album) {
    for (int i = 0; i < albums.length; i++) {
      if (album.name.compareTo(albums[i].name) < 0) {
        albums.insert(i, album);
        return;
      }
    }
    albums.add(album);
  }

  void insertArtist(Artist artist) {
    for (int i = 0; i < artists.length; i++) {
      if (artist.name.compareTo(artists[i].name) < 0) {
        artists.insert(i, artist);
        return;
      }
    }
    artists.add(artist);
  }

  void createPlaylist(String name) {
    playlists.add(Playlist(name));
  }
}
