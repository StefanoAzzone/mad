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
  String clientId = "78ca50e274ca45e8b9bf23d451748e2f";
  String clientSecret = "80b9db3e3b2e4f9ba283a0b1e07af86d";
  String token = "";
  SpotifyApi? spotify;

  MetadataLoader() {
    SpotifyApiCredentials credentials =
        SpotifyApiCredentials(clientId, clientSecret);
    spotify = SpotifyApi(credentials);
  }

  void initialize() async {
    if (token == "") {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      //AUTHENTICATION//
      http.Response response = await http.post(
          Uri.parse(accounts + authReqEndPoint),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization':
                'Basic ' + stringToBase64.encode(clientId + ":" + clientSecret),
          },
          body: <String, String>{
            'grant_type': 'client_credentials',
          });

      token = jsonDecode(response.body)['access_token'];
      print(response.body);
      print(token);

      //SEARCH//
      String url =
          base + searchEndPoint + "?" + "q=track:American%20Idiot&type=track";
      print(url);
      response = await http.get(Uri.parse(url), headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      });

      print(response.body);
    }
  }

  // Future searchArtist(String artist) async {
  //   if (spotify != null) {
  //     var search = await spotify?.search
  //         .get(artist)
  //         .first(1)
  //         .catchError((err) => print((err as SpotifyException).message));
  //     if (search == null) {
  //       return;
  //     }
  //     search.forEach((pages) {
  //       pages.items?.forEach((item) {
  //         if (item is Artist) {
  //           print('Artist: \n'
  //               'id: ${item.id}\n'
  //               'name: ${item.name}\n'
  //               'href: ${item.href}\n'
  //               'type: ${item.type}\n'
  //               'uri: ${item.uri}\n'
  //               '-------------------------------');
  //         }
  //         if (item is Show) {
  //           print('Show\n');
  //         }
  //         if (item is TrackSimple) {
  //           print('TrackSimple:\n');
  //         }
  //         if (item is AlbumSimple) {
  //           print('AlbumSimple:\n');
  //         }
  //       });
  //     });
  //   }
  // }

  // Future searchAlbum(String title) async {
  //   if (spotify != null) {
  //     var search = await spotify?.search
  //         .get(title)
  //         .first(1)
  //         .catchError((err) => print((err as SpotifyException).message));
  //     if (search == null) {
  //       return Future(() => null);
  //     }
  //     search.forEach((pages) {
  //       pages.items?.forEach((item) {
  //         if (item is AlbumSimple) {
  //           data.Album album = data.Album(
  //               item.name ?? "Unknown",
  //               item.artists?[0].name ?? "Unknown",
  //               image.Image.network(item.images?[0].url ??
  //                   "https://awsimages.detik.net.id/visual/2021/04/29/infografis-terbongkar-tesla-elon-musk-miliki-miliaran-bitcoinaristya-rahadian_43.jpeg?w=450&q=90"));
  //         }
  //       });
  //     });
  //   }
  //   return Future(() => null);
  // }

  // Future searchTrack(String title) async {
  //   if (spotify != null) {
  //     var search = await spotify?.search
  //         .get(title)
  //         .first(1)
  //         .catchError((err) => print((err as SpotifyException).message));
  //     if (search == null) {
  //       return Future(() => null);
  //     }
  //     search.forEach((pages) {
  //       pages.items?.forEach((item) {
  //         if (item is TrackSimple) {
  //           data.Track track = data.Track(
  //             item.name ?? "Unknown",
  //             title,
  //             await searchArtist(item.artists?[0].name),
  //             await searchArtist(item.)
  //              this.album, this.lyrics,
  //     this.trackNumber);
  //           data.Album album = data.Album(
  //               item.name ?? ,
  //               item.artists?[0].name ?? "Unknown",
  //               image.Image.network(item.images?[0].url ??
  //                   "https://awsimages.detik.net.id/visual/2021/04/29/infografis-terbongkar-tesla-elon-musk-miliki-miliaran-bitcoinaristya-rahadian_43.jpeg?w=450&q=90"));
  //         }
  //       });
  //     });
  //   }
  //   return Future(() => null);
  // }
}
