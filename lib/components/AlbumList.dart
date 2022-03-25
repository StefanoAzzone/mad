import 'package:flutter/material.dart';
import 'package:mad/buttons/AlbumCard.dart';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatefulWidget {
  List<Album> albums;
  AlbumList(this.albums, {Key? key}) : super(key: key);
  @override
  State<AlbumList> createState() => _AlbumListState(albums);
}

class _AlbumListState extends State<AlbumList> {
  List<Album> albums;

  _AlbumListState(this.albums);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        int ncols = orientation == Orientation.portrait ? 2 : 4;
        return GridView.count(
            childAspectRatio: 0.81,
            padding: const EdgeInsets.only(top: 0.0),
            crossAxisCount: ncols,
            children: List.generate(albums.length, (index) {
              return IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    ExtractArgumentsAlbumTracks.routeName,
                    arguments: albums[index],
                  );
                  setState(() {});
                },
                icon: AlbumCard(albums[index], ncols),
              );
            }));
      },
    );
  }
}
