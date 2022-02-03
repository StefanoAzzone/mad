import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/src/widgets/image.dart' as img;

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:crypto/crypto.dart';
import 'package:mad/metadata_loader.dart';
import 'package:path/path.dart' as p;
import 'dart:convert'; // for the utf8.encode method
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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
      json["title"],
      json["path"],
      database.containsArtist(json["artist"]) ?? Database.UnknownArtist,
      database.containsAlbum(json["album"]) ?? Database.UnknownAlbum,
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

  static Future<Artist> fromJson(Map<String, dynamic> json) async {
    File file = File(
        (await database._artistsDirectory).path + '/' + json["id"].toString());

    return Artist(
        json["name"],
        await file.exists()
            ? img.Image.memory(await file.readAsBytes())
            : defaultImage);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
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

  static Future<Album> fromJson(Map<String, dynamic> json) async {
    File file = File(
        (await database._coversDirectory).path + '/' + json["id"].toString());

    return Album(
        json["name"],
        database.containsArtist(json["Artist"]) ?? Database.UnknownArtist,
        await file.exists()
            ? img.Image.memory(await file.readAsBytes())
            : defaultImage);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'Artist': artist.id,
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

  static Playlist fromJson(Map<String, dynamic> json) {
    Playlist p = Playlist(json["name"]);
    for (var i = 0; i < json["traks"].length; i++) {
      Track? t = database.containsTrack(json["traks"](i));
      if (t != null) {
        p.addTrack(t);
      }
    }
    return p;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'traks': tracks.map((e) => e.id).toList(),
      };
}

TrackQueue trackQueue = TrackQueue.instance;

class TrackQueue {
  Random rng = Random();
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

  void addList(List<Track> tracks) {
    queue.addAll(tracks);
  }

  void shuffle() {
    queue.shuffle();
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

  Future<Directory> get _coversDirectory async {
    String path = (await getApplicationDocumentsDirectory()).path;
    Directory dir = Directory(path + "/MBox/Covers");
    if (!await dir.exists()) {
      print("Creating albums cover folder: " + path + "/MBox/Covers");
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<Directory> get _artistsDirectory async {
    String path = (await getApplicationDocumentsDirectory()).path;
    Directory dir = Directory(path + "/MBox/Artists");
    if (!await dir.exists()) {
      print("Creating artists image folder: " + path + "/MBox/Artists");
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> get _savedDB async {
    String path = (await getApplicationDocumentsDirectory()).path;
    File file = File(path + "/MBox/db");
    if (!await file.exists()) {
      print("Creating DB file: " + path + "/MBox/db");
      await file.create(recursive: true);
    }
    return file;
  }

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
        'playlists': playlists.map((e) => e.toJson()).toList(),
      };

  Future fromJson(Map<String, dynamic> json) async {
    return Future(() async {
      for (var e in (json['artists'] as List<dynamic>)) {
        insertArtist(await Artist.fromJson(e as Map<String, dynamic>));
      }

      for (var e in (json['albums'] as List<dynamic>)) {
        insertAlbum(await Album.fromJson(e as Map<String, dynamic>));
      }

      for (var e in (json['tracks'] as List<dynamic>)) {
        insertTrack(await Track.fromJson(e as Map<String, dynamic>));
      }

      playlists = ((json['playlists'] as List<dynamic>)
          .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList());
    });
  }

  void init(Function update) async {
    state = DatabaseState.Loading;
    await loader.initialize();
    //deleteAll();
    loadData(update);
    //insertAlbum(UnknownAlbum);
    //insertArtist(UnknownArtist);
    //findMusic(update);
    state = DatabaseState.Ready;
  }

  void loadData(Function update) async {
    String path = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory(path + "/MBox");
    if (!await directory.exists()) {
      print("No saved data.");
      return;
    }
    File savedDB = File(directory.path + "/db");
    if (!await savedDB.exists()) {
      print("No saved data.");
      return;
    }

    try {
      String JsonDB = await savedDB.readAsString();
      await fromJson(jsonDecode(JsonDB));
      update();
    } catch (e) {
      print("Error while loading data.");
    }
  }

  Future deleteAll() async {
    (await _artistsDirectory).delete(recursive: true);
    (await _coversDirectory).delete(recursive: true);
    (await _savedDB).delete(recursive: true);
  }

  void saveArtistImage(int id, Uint8List? image) async {
    if (image != null) {
      File file = File((await _artistsDirectory).path + '/' + id.toString());
      if (!await file.exists()) {
        print("Creating file " + file.path);
        await file.create();
      }
      file.writeAsBytes(image);
    }
  }

  void saveAlbumCover(int id, Uint8List? image) async {
    if (image != null) {
      File file = File((await _coversDirectory).path + '/' + id.toString());
      if (!await file.exists()) {
        print("Creating file " + file.path);
        await file.create();
      }
      file.writeAsBytes(image);
    }
  }

  ///
  /// Delete saved database and save it anew
  ///
  void saveAllData() async {
    (await _savedDB).delete();

    File db = await _savedDB;
    print("Recreating file " + db.path);

    try {
      String JsonDB = jsonEncode(toJson());
      await db.writeAsString(JsonDB, mode: FileMode.write, flush: true);
    } catch (e) {
      print("Error while saving data.");
    }
  }

  void findMusic(Function update) async {
    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    

    List<FileSystemEntity> files = Directory(MUSIC_PATH).listSync();
    for (var i = 0; i < files.length; i++) {
      if (SUPPORTED_FORMATS.contains(p.extension(files[i].path))) {
        Tag? tag = await tagger.readTags(
          path: files[i].path,
        );
        String? title = tag?.title;

        if (tag != null &&
            tag.title != null &&
            tag.album != null &&
            tag.artist != null &&
            (containsTrack(hash(tag.title! + tag.artist! + tag.album!)) !=
                null)) {
          //If the file was already loaded skip this iteration
          continue;
        }

        var info = null;
        if (connected == true) {
          info = await loader.searchFirstTrack(
              title != null && title != "" ? title : p.basename(files[i].path));
        }

        if (info == null) {
          //cannot find info: try to use tags
          String title = tag?.title ?? "";
          String artistName = tag?.artist ?? "";
          Artist artist = artistName != ""
              ? Artist(artistName, defaultImage)
              : UnknownArtist;
          insertArtist(artist);
          String albumName = tag?.album ?? "";
          Uint8List? cover = await tagger.readArtwork(path: files[i].path);
          Album album = albumName != ""
              ? Album(albumName, artist,
                  cover != null ? img.Image.memory(cover) : defaultImage)
              : UnknownAlbum;
          insertAlbum(album);
          saveAlbumCover(album.id, cover);
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
    state = DatabaseState.Ready;
    saveAllData();
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

      Uint8List? image;
      if (item == null) {
        //Artist not found
        artist = Artist(artistName, defaultImage);
      } else {
        //Artist found
        image = await loader.getArtistImage(loader.extractId(item));
        artist = (image == null)
            ? Artist(loader.extractArtistNameFromArtist(item), defaultImage)
            : Artist(loader.extractArtistNameFromArtist(item),
                img.Image.memory(image));
      }

      tmpArtist = containsArtist(artist.id);
      if (tmpArtist == null) {
        saveArtistImage(artist.id, image);
        insertArtist(artist);
      } else {
        artist = tmpArtist;
      }
    }

    Album album;
    Album? tmpAlbum;
    if (albumName == "" || albumName == null) {
      //tag missing
      tmpAlbum = containsAlbum(hash(loader.extractAlbumNameFromTrack(item) +
          loader.extractArtistNameFromTrack(item)));
      if (tmpAlbum == null) {
        album = await createAlbumFromTrack(item, artist);
        insertAlbum(album);
      } else {
        album = tmpAlbum;
      }
      //await tagger.writeTag(path: path, tagField: "album", value: album.name);
      print("album " + album.name + " not in tags; used API instead");
    } else {
      //tag present
      tmpAlbum = containsAlbum(hash(albumName + artist.name));
      if (tmpAlbum == null) {
        Uint8List? cover = await tagger.readArtwork(path: path);
        if (cover != null) {
          album = Album(albumName, artist, img.Image.memory(cover));
        } else {
          var item = await loader.searchAlbum(albumName);

          Uint8List? cover = null;
          if (item == null) {
            //Album not found
            album = Album(albumName, artist, defaultImage);
          } else {
            //Album found
            cover = await loader.extractCoverFromAlbum(item);
            album = Album(loader.extractAlbumTitleFromAlbum(item), artist,
                img.Image.memory(cover));
          }
        }
        saveAlbumCover(album.id, cover);
        insertAlbum(album);
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

  Future<Album> createAlbumFromTrack(var item, Artist artist) async {
    Uint8List cover = await loader.extractCoverFromTrack(item);
    Album album = Album(loader.extractAlbumNameFromTrack(item), artist,
        img.Image.memory(cover));
    saveAlbumCover(album.id, cover);
    return album;
  }

  Future<Artist> createArtistFromTrack(var item) async {
    Uint8List? image =
        await loader.getArtistImage(loader.extractArtistIdFromTrack(item));
    Artist artist = Artist(loader.extractArtistNameFromTrack(item),
        image == null ? defaultImage : img.Image.memory(image));
    saveArtistImage(artist.id, image);
    return artist;
  }

  Artist? containsArtist(int Id) {
    for (int i = 0; i < artists.length; i++) {
      if (artists[i].id == Id) return artists[i];
    }
    return null;
  }

  Album? containsAlbum(int Id) {
    for (int i = 0; i < albums.length; i++) {
      if (albums[i].id == Id) return albums[i];
    }
    return null;
  }

  Track? containsTrack(int Id) {
    for (int i = 0; i < tracks.length; i++) {
      if (tracks[i].id == Id) return tracks[i];
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

  void insertAlbum(Album album) async {
    for (int i = 0; i < albums.length; i++) {
      if (album.name.compareTo(albums[i].name) < 0) {
        albums.insert(i, album);
        return;
      }
    }
    File file = File((await _coversDirectory).path + '/' + album.id.toString());

    albums.add(album);
    album.artist.addAlbum(album);
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
