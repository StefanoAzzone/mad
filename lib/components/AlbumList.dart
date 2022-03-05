import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:mad/screens/AlbumTracks.dart';

class AlbumList extends StatefulWidget {
  List<Album> albums;
  AlbumList(this.albums);
  @override
  State<AlbumList> createState() => _AlbumListState(albums);
}

class _AlbumListState extends State<AlbumList> {
  late Offset _tapPosition;
  List<Album> albums;

  _AlbumListState(this.albums);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        int ncols = orientation == Orientation.portrait ? 2 : 4;
        return GridView.count(
            childAspectRatio: 0.81,
            padding: EdgeInsets.only(top: 0.0),
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
                  icon: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: albums[index].cover,
                          width: size.width / ncols - 20,
                          height: size.width / ncols - 20,
                        ),
                        Text(
                          ' ' + albums[index].name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,

                          ),
                        ),
                        Text(
                          ' ' + albums[index].artist.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,

                          ),
                        ),
                      ],
                    )
                  ),
              );
            })
        );
      },
    );
  }
}
