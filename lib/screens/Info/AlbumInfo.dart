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
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.indigo, Colors.lightBlue])),
              ),
              title: Text(loader.extractAlbumTitleFromAlbum(album)),
              centerTitle: true,
            ),
            body: FutureBuilder(
                future: loader.getTracksOfAlbum(loader.extractId(album)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    return Column(children: [
                      Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 0.5,
                                  mainAxisSpacing: 0.5,
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 1
                                          : 2,
                                  childAspectRatio: 7,
                                ),
                                itemCount: loader.getItemsCount(snapshot.data),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                loader
                                                    .extractTrackNumberFromTrack(
                                                        loader.getItem(
                                                            snapshot.data,
                                                            index))
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.right,
                                              ),
                                              width: 20,
                                            ),
                                            Text(
                                              '  ' +
                                                  loader.extractTitleFromTrack(
                                                      loader.getItem(
                                                          snapshot.data,
                                                          index)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          String url = await loader
                                              .queryYouTubeUrl(loader
                                                      .extractTitleFromTracks(
                                                          snapshot.data,
                                                          index) +
                                                  ' ' +
                                                  loader
                                                      .extractArtistFromTracks(
                                                          snapshot.data,
                                                          index));
                                          await launch(url);
                                        }),
                                  );
                                })),
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
