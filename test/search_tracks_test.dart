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

  test('lyrics',
    () async {
      await loader.initialize();
      var info = await loader.searchAllTracks('American Idiot');
      var lyrics = await loader.getLyricsFromTrack(info[0]);
      expect(lyrics, contains('Welcome to a new kind of tension'));
    }
  );

  test('YouTube',
    () async {
      await loader.initialize();
      var info = await loader.queryYouTubeUrl('American Idiot');
      expect(info, "http://youtube.com/watch?v=Ee_uujKuJMI");
    }
  );

  test('Wikipedia',
    () async {
      await loader.initialize();
      var info = await loader.getWikipedia('Green Day');
      expect(info, contains("Green Day is an American rock band formed in the East Bay of California"));
    }
  );

  test('getAlbumTracks',
    () async {
      await loader.initialize();
      var track = await loader.searchFirstTrack('Jesus of Suburbia');
      var albumId = await loader.extractAlbumIdFromTrack(track);
      var tracks = await loader.getTracksOfAlbum(albumId);
      expect(loader.extractTitleFromTrack(tracks[0]), "American Idiot");
      expect(loader.extractTitleFromTrack(tracks[1]), "Jesus of Suburbia");
      expect(loader.extractTitleFromTrack(tracks[2]), "Holiday / Boulevard of Broken Dreams");
    }
  );
}