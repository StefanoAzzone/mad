import 'package:flutter/material.dart';
import 'package:mad/buttons/AlbumCard.dart';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatefulWidget {
  final List<Album> albums;
  const AlbumList(this.albums, {Key? key}) : super(key: key);
  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        int ncols = orientation == Orientation.portrait ? 2 : 4;
        return GridView.count(
            childAspectRatio: 0.81,
            padding: const EdgeInsets.only(top: 0.0),
            crossAxisCount: ncols,
            children: List.generate(widget.albums.length, (index) {
              return IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    ExtractArgumentsAlbumTracks.routeName,
                    arguments: widget.albums[index],
                  );
                  setState(() {});
                },
                icon: AlbumCard(widget.albums[index], ncols),
              );
            }));
      },
    );
  }
}
