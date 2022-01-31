import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class AlbumInfo extends StatelessWidget {
  var album;
  AlbumInfo(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: loader.getItemsCount(snapshot.data),
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(loader.extractTitleFromTrack(
                                    loader.getItem(snapshot.data, index))),
                                onTap: () => print("Searchinh " +
                                    loader.extractTitleFromTrack(
                                        loader.getItem(snapshot.data, index)) +
                                    " on Youtube"));
                          })),
                  PlayBar(),
                ]);
              }
            }));
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
