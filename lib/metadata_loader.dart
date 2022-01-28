import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mad/data.dart' as data;
import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as image;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

MetadataLoader loader = MetadataLoader.instance;

class MetadataLoader {
  String base = "https://api.spotify.com";
  String genius = "https://api.genius.com";
  String accounts = "https://accounts.spotify.com";
  String authReqEndPoint = "/api/token";
  String searchEndPoint = "/v1/search";
  String ArtistsEndPoint = "/v1/artists";
  String AlbumsEndPoint = "/v1/albums";
  String lyricsSearchEndpoint = "/search";
  String clientIdSpotify = "78ca50e274ca45e8b9bf23d451748e2f";
  String clientSecretSpotify = "80b9db3e3b2e4f9ba283a0b1e07af86d";
  // String clientIdGenius =
  //     "fSJ3EY4K-_ZNnUJUsglEVdjX0v0dPsVZo-Qu45LURNX2_xJcJ2FmzA0se4gRyALF";
  // String clientSecretGenius =
  //     "p_g9Z4TY7_EjxvIm_zRVqozPk0grPuWhvVcRAjRmi0foNUFDGrM8bRZ-L6w6xUbgqnh5ofqwm2hUqPSyd_UMxQ";
  String spotifyToken = "";
  String geniusToken =
      "LRi1LM1TgabWwrVhI78JPkwOnI2zkHWRBtq2OEB-uADCcUdEd7Dr_ZMD0kzhh74h";
  static final MetadataLoader instance = MetadataLoader._internal();

  factory MetadataLoader() {
    return instance;
  }
  MetadataLoader._internal();

  Future initialize() async {
    return Future(() async {
      if (spotifyToken == "") {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        //SPOTIFY AUTHENTICATION//
        http.Response response = await http.post(
            Uri.parse(accounts + authReqEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' +
                  stringToBase64
                      .encode(clientIdSpotify + ":" + clientSecretSpotify),
            },
            body: <String, String>{
              'grant_type': 'client_credentials',
            });

        spotifyToken = jsonDecode(response.body)['access_token'];
        print(response.body);
      }
    });
  }

  Future<data.Artist> searchArtist(String artist) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("artist:" + artist + "&type=artist"));

    var items = jsonDecode(response.body)["artists"]["items"];

    return Future(() => items[0]);
  }

  Future searchAlbum(String title) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("album:" + title + "&type=album"));

    var items = jsonDecode(response.body)["albums"]["items"];

    return Future(() => items[0]);
  }

  Future searchFirstTrack(String title) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("track:" + title + "&type=track"));

    var items = jsonDecode(response.body)["tracks"]["items"];

    return Future(() => items.length != 0 ? items[0] : null);
  }

  Future searchAllTracks(String title) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("track:" + title + "&type=track"));

    var items = jsonDecode(response.body)["tracks"]["items"];

    return Future(() => items.length != 0 ? items : null);
  }

  int getItemsCount(var items) {
    return items != null ? items.length : 0;
  }

  Map getItem(var items, int index) {
    return items[index];
  }

  String extractAlbumTitleFromAlbum(var item) {
    return item["name"];
  }

  String extractArtistNameFromAlbum(var item) {
    return item["artists"][0]["name"];
  }

  String extractArtistIdFromAlbum(var item) {
    return item["artists"][0]["id"];
  }

  image.Image extractCoverFromAlbum(var item) {
    return image.Image.network(item["images"][0]["url"]);
  }

  String extractTitleFromTrack(var item) {
    return item["name"];
  }

  String extractTitleFromTracks(var items, int index) {
    return items[index]["name"];
  }

  String extractArtistFromTracks(var items, int index) {
    return items[index]["artists"][0]["name"];
  }

  image.Image extractThumbnailUrlFromTracks(var items, int index) {
    var tmp = items[index]["album"]["images"];

    return image.Image.network(tmp[tmp.length - 1]["url"]);
  }

  String extractArtistNameFromTrack(var item) {
    return item["artists"][0]["name"];
  }

  String extractArtistIdFromTrack(var item) {
    return item["artists"][0]["id"];
  }

  String extractAlbumNameFromTrack(var item) {
    return item["album"]["name"];
  }

  String extractAlbumIdFromTrack(var item) {
    return item["album"]["id"];
  }

  int extractTrackNumberFromTrack(var item) {
    return item["track_number"];
  }

  image.Image extractCoverFromTrack(var item) {
    return image.Image.network(item["album"]["images"][0]["url"]);
  }

  Future<String> getLyricsFromTrack(var item) async {
    return await queryLyrics(
        extractTitleFromTrack(item) + " " + extractArtistNameFromTrack(item));
  }

  Future<String> queryLyrics(String query) async {
    String lyrics = "";
    String url = genius +
        lyricsSearchEndpoint +
        "?" +
        "q=" +
        query +
        "&access_token=" +
        geniusToken;
    print(url);
    http.Response response = await http.get(Uri.parse(url));

    var json = jsonDecode(response.body);
    if (json["response"]["hits"].length != 0) {
      url = genius +
          json["response"]["hits"][0]["result"]["api_path"] +
          "?access_token=" +
          geniusToken;
      response = await http.get(Uri.parse(url));

      json = jsonDecode(response.body);
      url = json["response"]["song"]["url"] + "?access_token=" + geniusToken;
      response = await http.get(Uri.parse(url));

      List lyricsNodes = parser
          .parse(response.body)
          .getElementsByClassName('Lyrics__Container-sc-1ynbvzw-6 jYfhrf');

      lyrics = parseLyrics(lyricsNodes);
    }

    return lyrics;
  }

  String parseLyrics(var nodes) {
    String lyrics = "";
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].firstChild == null) {
        if (nodes[i].text != "") {
          lyrics += nodes[i].text + "\n";
        }
      } else {
        lyrics += parseLyrics(nodes[i].nodes);
      }
    }
    return lyrics;
  }

  Future<http.Response> queryAPI(String query) {
    String url = base + searchEndPoint + "?" + "q=" + query;
    // print(url);
    return http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + spotifyToken,
    });
  }

  Future<image.Image> getArtistImage(String Id) async {
    String url = base + ArtistsEndPoint + "/" + Id;
    http.Response response =
        await http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + spotifyToken,
    });
    return Future<image.Image>(() {
      return image.Image.network(jsonDecode(response.body)["images"][0]["url"]);
    });
  }
}
