import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mad/metadata_loader.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mock.mocks.dart' as Mock;
import 'dart:convert';

Codec<String, String> stringToBase64 = utf8.fuse(base64);

@GenerateMocks([http.Client])
void main() {
  test('Connection and spotify authentication', () async {
    final clientUnconnected = Mock.MockClient();
    final client = Mock.MockClient();

    when(clientUnconnected.get(Uri.parse('http://google.com')))
        .thenAnswer((_) async => http.Response('{"nope"}', 404));

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

    await loader.initializeWithClient(clientUnconnected);

    expect(loader.connected, false);

    await loader.initializeWithClient(client);

    expect(loader.connected, true);
    expect(loader.spotifyToken,
        "BQDaAjD2tgJ_ojhhmCkCY-jlRdqsKZzV0D72CZI3JkRVphIpOtSmPmLGnbBaW2A-BLE1CvVHULtYMhHcjWHQtBBUMGGETkDuIR08eLHdONvzgN3_Jw3A");
  });
}
