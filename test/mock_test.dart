import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mad/metadata_loader.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mock.mocks.dart' as Mock;
import 'dart:convert';
import './Response/SearchArtistResp.dart';
import './Response/WikiResp.dart';

Codec<String, String> stringToBase64 = utf8.fuse(base64);
String token =
    "BQDaAjD2tgJ_ojhhmCkCY-jlRdqsKZzV0D72CZI3JkRVphIpOtSmPmLGnbBaW2A-BLE1CvVHULtYMhHcjWHQtBBUMGGETkDuIR08eLHdONvzgN3_Jw3A";

@GenerateMocks([http.Client])
void main() {
  test('Connection', () async {
    final clientUnconnected = Mock.MockClient();
    final client = Mock.MockClient();

    when(clientUnconnected.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"nope"}', 404));

    when(client.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"yep"}', 200));

    await loader.initializeWithClient(clientUnconnected);

    expect(loader.connected, false);

    await loader.initializeWithClient(client);

    expect(loader.connected, true);
  });

  test('Spotify authentication', () async {
    final client = Mock.MockClient();

    when(client.post(Uri.parse('https://accounts.spotify.com/api/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ' +
              stringToBase64.encode(
                  loader.clientIdSpotify + ":" + loader.clientSecretSpotify),
        },
        body: <String, String>{
          'grant_type': 'client_credentials',
        })).thenAnswer((_) async => http.Response(
        '{"access_token":"BQDaAjD2tgJ_ojhhmCkCY-jlRdqsKZzV0D72CZI3JkRVphIpOtSmPmLGnbBaW2A-BLE1CvVHULtYMhHcjWHQtBBUMGGETkDuIR08eLHdONvzgN3_Jw3A","token_type":"Bearer","expires_in":3600}',
        200));

    when(client.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"yep"}', 200));

    await loader.initializeWithClient(client);
    expect(loader.spotifyToken, token);
  });

  test('searchArtist', () async {
    final client = Mock.MockClient();

    when(client.post(Uri.parse('https://accounts.spotify.com/api/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ' +
              stringToBase64.encode(
                  loader.clientIdSpotify + ":" + loader.clientSecretSpotify),
        },
        body: <String, String>{
          'grant_type': 'client_credentials',
        })).thenAnswer((_) async => http.Response(
        '{"access_token":"BQDaAjD2tgJ_ojhhmCkCY-jlRdqsKZzV0D72CZI3JkRVphIpOtSmPmLGnbBaW2A-BLE1CvVHULtYMhHcjWHQtBBUMGGETkDuIR08eLHdONvzgN3_Jw3A","token_type":"Bearer","expires_in":3600}',
        200));

    when(client.get(
        Uri.parse(
            "https://api.spotify.com/v1/search?query=artist:Green%20Day&type=artist&market=IT&offset=0&limit=20"),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token,
        })).thenAnswer((_) async => http.Response(searchArtistResp, 200));

    when(client.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"yep"}', 200));

    loader.spotifyToken = token;
    loader.client = client;

    var res = await loader.searchAllArtists("Green Day");

    expect(res[0]["name"], "Green Day");
    expect(res[0]["type"], "artist");
    expect(res[0]["popularity"], 77);
    expect(loader.extractArtistNameFromArtist(loader.getItem(res, 0)),
        "Green Day");

    expect(res[0]["images"][0]["url"],
        "https://i.scdn.co/image/ab6761610000e5eb047eac333eff0be4abe32cbf");
  });

  test('extract,', () async {
    final client = Mock.MockClient();

    when(client.get(
        Uri.parse(
            "https://api.spotify.com/v1/search?query=artist:Green%20Day&type=artist&market=IT&offset=0&limit=20"),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token,
        })).thenAnswer((_) async => http.Response(searchArtistResp, 200));

    when(client.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"yep"}', 200));

    loader.spotifyToken = token;
    loader.client = client;

    var res = await loader.searchAllArtists("Green Day");

    expect(loader.extractArtistNameFromArtist(loader.getItem(res, 1)),
        "Dayon Greene");
    expect(loader.extractArtistNameFromArtist(loader.getItem(res, 3)),
        "Daye Greene");
    expect(loader.extractArtistNameFromArtist(loader.getItem(res, 7)),
        "All Day Green");
  });

  test('lyrics', () async {
    await loader.initialize();
    var info = await loader.searchAllTracks('American Idiot');
    var lyrics = await loader.getLyricsFromTrack(info[0]);
    expect(lyrics, contains('Welcome to a new kind of tension'));
  });

  test('YouTube', () async {
    await loader.initialize();
    var info = await loader.queryYouTubeUrl('American Idiot');
    expect(info, "http://youtube.com/watch?v=Ee_uujKuJMI");
  });

  test('Wikipedia', () async {
    await loader.initialize();
    var info = await loader.getWikipedia('Green Day');
    expect(
        info,
        contains(
            "Green Day is an American rock band formed in the East Bay of California"));
  });

  test('WikipediaMock', () async {
    final client = Mock.MockClient();

    when(client.post(Uri.parse('https://accounts.spotify.com/api/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ' +
              stringToBase64.encode(
                  loader.clientIdSpotify + ":" + loader.clientSecretSpotify),
        },
        body: <String, String>{
          'grant_type': 'client_credentials',
        })).thenAnswer((_) async => http.Response(
        '{"access_token":"BQDaAjD2tgJ_ojhhmCkCY-jlRdqsKZzV0D72CZI3JkRVphIpOtSmPmLGnbBaW2A-BLE1CvVHULtYMhHcjWHQtBBUMGGETkDuIR08eLHdONvzgN3_Jw3A","token_type":"Bearer","expires_in":3600}',
        200));

    when(client.get(
      Uri.parse(
          "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exintro&format=json&explaintext&titles=Green%20Day"),
    )).thenAnswer((_) async => http.Response(wikiResp, 200));

    loader.spotifyToken = token;
    loader.client = client;

    final info = await loader.getWikipedia('Green Day');

    expect(
        info,
        contains(
            "Green Day is an American rock band formed in the East Bay of California"));
  });

  test('getAlbumTracks', () async {
    await loader.initialize();
    var track = await loader.searchFirstTrack('Jesus of Suburbia');
    var albumId = await loader.extractAlbumIdFromTrack(track);
    var tracks = await loader.getTracksOfAlbum(albumId);
    expect(loader.extractTitleFromTrack(tracks[0]), "American Idiot");
    expect(loader.extractTitleFromTrack(tracks[1]), "Jesus of Suburbia");
    expect(loader.extractTitleFromTrack(tracks[2]),
        "Holiday / Boulevard of Broken Dreams");
  });

  test('searchTracks', () async {
    await loader.initialize();
    var info = await loader.searchAllTracks('Jesus of Suburbia');
    expect(loader.extractAlbumNameFromTrack(info[0]), 'American Idiot');
    expect(loader.extractArtistNameFromTrack(info[0]), 'Green Day');
    expect(loader.extractTrackNumberFromTrack(info[0]), 2);
    expect(loader.extractTitleFromTrack(info[0]), 'Jesus of Suburbia');
  });
}
