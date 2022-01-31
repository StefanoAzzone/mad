import 'package:flutter/material.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/metadata_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class AlbumInfo extends StatelessWidget {
  
  
  var album;
  AlbumInfo(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text(loader.extractAlbumTitleFromAlbum(album)),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: loader.getTracksOfAlbum(loader.extractId(album)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(children: [
                    Expanded(
                            child: GridView.count(
                            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                            children: List<ListTile>.generate(
                                loader.getItemsCount(snapshot.data), (index) {
                              return ListTile(
                                  title: Text(loader.extractTitleFromTrack(
                                      loader.getItem(snapshot.data, index))),
                                  onTap: () async {

                                    String url = await loader.queryYouTubeUrl(
                                      loader.extractTitleFromTracks(snapshot.data, index)
                                      + ' ' +
                                      loader.extractArtistFromTracks(snapshot.data, index));
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else 
                                      // can't launch url, there is some error
                                      throw "Could not launch $url";
                                  });
                            }))
                            ),
                    PlayBar(),
                  ]);
                }
              }));

        },
    );
  }
}

class ExtractArgumentsAlbumInfo extends StatelessWidget {
  const ExtractArgumentsAlbumInfo({Key? key}) : super(key: key);

  static const routeName = '/albumInfo';

  @override
  Widget build(BuildContext context) {
    final album = ModalRoute.of(context)!.settings.arguments;

    return AlbumInfo(album);
  }
}
