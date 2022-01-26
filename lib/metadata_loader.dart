import 'dart:convert';

import 'package:mad/data.dart' as data;
import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as image;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MetadataLoader {
  String base = "https://api.spotify.com";
  String accounts = "https://accounts.spotify.com";
  String authReqEndPoint = "/api/token";
  String searchEndPoint = "/v1/search";
  String ArtistsEndPoint = "/v1/artists";
  String AlbumsEndPoint = "/v1/albums";
  String clientId = "78ca50e274ca45e8b9bf23d451748e2f";
  String clientSecret = "80b9db3e3b2e4f9ba283a0b1e07af86d";
  String token = "";
  SpotifyApi? spotify;

  MetadataLoader() {
    SpotifyApiCredentials credentials =
        SpotifyApiCredentials(clientId, clientSecret);
    spotify = SpotifyApi(credentials);
  }

  Future initialize() async {
    return Future(() async {
      if (token == "") {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        //AUTHENTICATION//
        http.Response response = await http.post(
            Uri.parse(accounts + authReqEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ' +
                  stringToBase64.encode(clientId + ":" + clientSecret),
            },
            body: <String, String>{
              'grant_type': 'client_credentials',
            });

        token = jsonDecode(response.body)['access_token'];
        print(response.body);
        print(token);
      }
    });
  }

  // void searchTrack(String artist) async {
  //   //SEARCH//
  //   String url =
  //       base + searchEndPoint + "?" + "q=track:American%20Idiot&type=track";
  //   print(url);
  //   http.Response response =
  //       await http.get(Uri.parse(url), headers: <String, String>{
  //     "Accept": "application/json",
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ' + token,
  //   });

  //   print(response.body);
  //   var items = jsonDecode(response.body)["tracks"]["items"];
  //   print(items);
  // }

  Future<data.Artist> searchArtist(String artist) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("artist:" + artist + "&type=artist"));

    var items = jsonDecode(response.body)["artists"]["items"];

    return Future(() => items[0]);

    // print(items);
    // return Future<data.Artist>(() => data.Artist(
    //     first["name"], image.Image.network(first["images"][0]["url"])));
  }

  Future searchAlbum(String title) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("album:" + title + "&type=album"));

    var items = jsonDecode(response.body)["albums"]["items"];

    return Future(() => items[0]);
  }

  Future searchTrack(String title) async {
    http.Response response =
        await queryAPI(Uri.encodeFull("track:" + title + "&type=track"));

    var items = jsonDecode(response.body)["tracks"]["items"];

    return Future(() => items.length != 0 ? items[0] : null);
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

  Future<http.Response> queryAPI(String query) {
    String url = base + searchEndPoint + "?" + "q=" + query;
    // print(url);
    return http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
  }

  Future<image.Image> getArtistImage(String Id) async {
    String url = base + ArtistsEndPoint + "/" + Id;
    http.Response response =
        await http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
    return Future<image.Image>(() {
      return image.Image.network(jsonDecode(response.body)["images"][0]["url"]);
    });
  }
}
