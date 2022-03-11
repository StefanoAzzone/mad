import 'package:flutter/material.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/metadata_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class AlbumInfo extends StatelessWidget {
  var album;
  AlbumInfo(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!loader.connected) {
      return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.indigo, Colors.lightBlue])),
            ),
          ),
          body: Center(
            child: Text(
                "Cannot access server.\nTry to check your internet connection."),
          ));
    }

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
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  orientation == Orientation.portrait ? 1 : 2,
                              childAspectRatio: 7,
                            ),
                            itemCount: loader.getItemsCount(snapshot.data),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                        width: 0.05, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 0.05, color: Colors.black),
                                  ),
                                ),
                                child: ListTile(
                                    title: Row(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            loader
                                                .extractTrackNumberFromTrack(
                                                    loader.getItem(
                                                        snapshot.data, index))
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                          width: 20,
                                        ),
                                        Container(
                                          width: 10,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                  width: 0.25,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '  ' +
                                                loader.extractTitleFromTrack(
                                                    loader.getItem(
                                                        snapshot.data, index)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      String url = await loader.queryYouTubeUrl(
                                          loader.extractTitleFromTracks(
                                                  snapshot.data, index) +
                                              ' ' +
                                              loader.extractArtistFromTracks(
                                                  snapshot.data, index));
                                      await launch(url);
                                    }),
                              );
                            }),
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
