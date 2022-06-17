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
  test('metadata_loader',
    () async {

      await loader.initialize();
      var info = await loader.searchAllTracks('Jesus of Suburbia');
      expect(loader.extractAlbumNameFromTrack(info[0]), 'American Idiot');
      expect(loader.extractArtistNameFromTrack(info[0]), 'Green Day');
      expect(loader.extractTrackNumberFromTrack(info[0]), 2);
      expect(loader.extractTitleFromTrack(info[0]), 'Jesus of Suburbia');
    }
  );
}