import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

MetadataLoader loader = MetadataLoader.instance;

class MetadataLoader {
  bool connected = false;
  int lastPingTime = 0;
  int lastTokenTime = 0;
  String base = "https://api.spotify.com";
  String genius = "https://api.genius.com";
  String accounts = "https://accounts.spotify.com";
  String authReqEndPoint = "/api/token";
  String searchEndPoint = "/v1/search";
  String artistsEndPoint = "/v1/artists";
  String albumsEndPoint = "/v1/albums";
  String lyricsSearchEndpoint = "/search";
  String clientIdSpotify = "78ca50e274ca45e8b9bf23d451748e2f";
  String clientSecretSpotify = "80b9db3e3b2e4f9ba283a0b1e07af86d";
  String youtubeSearchUrl = "https://www.youtube.com/results?search_query=";
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

  Future<bool> initialize() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    //Initialize if the token is missing or expired
    if (spotifyToken == "" || now - lastTokenTime > (3600 * 1000)) {
      if (!await checkConnection()) {
        //if not connected
        return false;
      }
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      //SPOTIFY AUTHENTICATION//
      try {
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
        return true;
      } catch (e) {
        print("Disconnected while trying to get Spotify token.");
        return false;
      }
    }
    return true;
  }

  Future<bool> checkConnection() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastPingTime > 1000) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          lastPingTime = now;
          if (connected == false) {
            connected = true;
            initialize();
          }
        } else {
          connected = false;
        }
      } on SocketException catch (_) {
        connected = false;
        print('not connected');
      }
    }
    return connected;
  }

  Future searchArtist(String artist) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull("artist:" + artist + "&type=artist"));

      var items = jsonDecode(response.body)["artists"]["items"];

      return Future(() => items.length != 0 ? items[0] : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future searchAlbum(String title) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull("album:" + title + "&type=album"));

      var items = jsonDecode(response.body)["albums"]["items"];

      return Future(() => items.length != 0 ? items[0] : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future searchFirstTrack(String title) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull(title + "&type=track"));

      var items = jsonDecode(response.body)["tracks"]["items"];
      return Future(() => items.length != 0 ? items[0] : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future searchAllTracks(String title) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull("track:" + title + "&type=track"));

      var items = jsonDecode(response.body)["tracks"]["items"];
      return Future(() => items.length != 0 ? items : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future searchAllCovers(String title) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull("album:" + title + "&type=album"));

      var items = jsonDecode(response.body)["albums"]["items"];
      return Future(() => items.length != 0 ? items : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future searchAllArtists(String title) async {
    try {
      http.Response response =
          await queryAPI(Uri.encodeFull("artist:" + title + "&type=artist"));

      var items = jsonDecode(response.body)["artists"]["items"];
      return Future(() => items.length != 0 ? items : null);
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  int getItemsCount(var items) {
    return items != null ? items.length : 0;
  }

  Map getItem(var items, int index) {
    return items != null ? items[index] : null;
  }

  String extractId(var item) {
    return item["id"];
  }

  String extractArtistNameFromArtist(var item) {
    return item["name"];
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

  Future<Uint8List> extractCoverFromAlbum(var item) async {
    String url = item["images"][0]["url"];
    return (await http.get(Uri.parse(url))).bodyBytes;
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

  Future<Uint8List?> extractThumbnailUrlFromTracks(var items, int index) async {
    try {
      var tmp = items[index]["album"]["images"];
      String url = tmp[tmp.length - 1]["url"];
      return (await http.get(Uri.parse(url))).bodyBytes;
    } catch (e) {
      await checkConnection();
      return null;
    }
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

  Future<Uint8List?> extractCoverFromTrack(var item) async {
    try {
      String url = item["album"]["images"][0]["url"];
      return (await http.get(Uri.parse(url))).bodyBytes;
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future getTracksOfAlbum(String albumId) async {
    try {
      return jsonDecode((await queryAlbumTracks(albumId)).body)['items'];
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future getAlbumsOfArtist(String artistName) async {
    try {
      String id = extractId(await searchArtist(artistName));
      return jsonDecode((await queryArtistAlbums(id)).body)['items'];
    } catch (e) {
      await checkConnection();
      return Future(() => null);
    }
  }

  Future<String> getLyricsFromTrack(var item) async {
    try {
      return await queryLyrics(extractTitleFromTrack(item).split(' - ')[0] +
          " " +
          extractArtistNameFromTrack(item));
    } catch (e) {
      await checkConnection();
      return "";
    }
  }

  Future<Uint8List?> getArtistImage(String Id) async {
    try {
      String url = base + artistsEndPoint + "/" + Id;
      http.Response response =
          await http.get(Uri.parse(url), headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + spotifyToken,
      });

      if (jsonDecode(response.body)["images"].length == 0) return null;
      url = jsonDecode(response.body)["images"][0]["url"];
      return (await http.get(Uri.parse(url))).bodyBytes;
    } catch (e) {
      await checkConnection();
      return null;
    }
  }

  Future<String> getWikipedia(String query) async {
    try {
      String url =
          'https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro&format=json&explaintext&titles=' +
              query;
      http.Response res =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 1));
      var json = jsonDecode(res.body) as Map;
      var ret = json["query"]["pages"].entries.toList()[0].value["extract"];
      return ret;
    } catch (e) {
      await checkConnection();
      return "";
    }
  }

  Future<http.Response> queryAPI(String query) {
    String url = base +
        searchEndPoint +
        "?" +
        "query=" +
        query +
        "&market=IT&offset=0&limit=20";
    return http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + spotifyToken,
    });
  }

  Future<http.Response> queryAlbumTracks(String id) {
    String url = base + albumsEndPoint + '/' + id + "/tracks";
    // print(url);
    return http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + spotifyToken,
    });
  }

  Future<http.Response> queryArtistAlbums(String id) {
    String url = base + artistsEndPoint + '/' + id + "/albums";
    // print(url);
    return http.get(Uri.parse(url), headers: <String, String>{
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + spotifyToken,
    });
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
    // print(url);
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

  Future<String> queryYouTubeUrl(String query) async {
    String url = youtubeSearchUrl + query;
    http.Response response = await http.get(Uri.parse(url));

    int i = response.body.indexOf("/watch?v=");
    int j = response.body.substring(i).indexOf('"');

    return "http://youtube.com" + response.body.substring(i, i + j);
  }

  String parseLyrics(var nodes) {
    String lyrics = "";
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].firstChild == null) {
        if (nodes[i].text != "") {
          if (nodes[i].text[0] == '[') {
            lyrics += '\n ' + nodes[i].text + "\n\n";
          } else {
            lyrics += nodes[i].text + "\n";
          }
        }
      } else {
        lyrics += parseLyrics(nodes[i].nodes);
      }
    }
    return lyrics;
  }
}
