import 'package:spotify/spotify.dart';

class MetadataLoader {
  //String base = "https://api.spotify.com";
  String clientId = "78ca50e274ca45e8b9bf23d451748e2f";
  String clientSecret = "80b9db3e3b2e4f9ba283a0b1e07af86d";
  SpotifyApi? spotify;

  MetadataLoader() {
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
  }

  void searchArtist(String artist) async {
    if(spotify != null) {
      var search = await spotify?.search
        .get(artist)
        .first(1)
        .catchError((err) => print((err as SpotifyException).message));
      if (search == null) {
        return;
      }
      search.forEach((pages) {
        pages.items!.forEach((item) {
          if (item is Artist) {
            print('Artist: \n'
                'id: ${item.id}\n'
                'name: ${item.name}\n'
                'href: ${item.href}\n'
                'type: ${item.type}\n'
                'uri: ${item.uri}\n'
                '-------------------------------');
          }
        });
      });
    }
  }
}