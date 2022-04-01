import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';
import 'package:mad/screens/ArtistAlbums.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({Key? key}) : super(key: key);

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  static final int unknownArtistID = Database.UnknownArtist.id;
  late Offset _tapPosition = Offset.zero;
  List<Artist> artists = Database.instance.artists;

  @override
  Widget build(BuildContext context) {
    bool toDelete = true;

    for (var album in Database.UnknownArtist.albumList) {
      if (album.trackList.isNotEmpty) {
        toDelete = false;
      }
    }

    if (toDelete) {
      artists.remove(Database.UnknownArtist);
    }

    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        int ncols = orientation == Orientation.portrait ? 3 : 5;
        return GridView.count(
            childAspectRatio: 0.9,
            padding: const EdgeInsets.only(top: 0.0),
            crossAxisCount: ncols,
            children: List.generate(artists.length, (index) {
              return GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _tapPosition = details.globalPosition;
                  },
                  onLongPress: () {
                    RenderObject? overlay =
                        Overlay.of(context)?.context.findRenderObject();
                    Size? size = overlay?.semanticBounds.size;
                    if (size != null) {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromRect(
                              _tapPosition &
                                  const Size(
                                      40, 40), // smaller rect, the touch area
                              Offset.zero &
                                  size // Bigger rect, the entire screen
                              ),
                          items: <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                value: 'Value1',
                                child: Column(children: [
                                  TextButton(
                                      onPressed: () async {
                                        await loader.checkConnection();
                                        var image = await Navigator.pushNamed(
                                            context, '/artistEditor',
                                            arguments: artists[index].name);
                                        if (image != null) {
                                          artists[index].image =
                                              Image.memory(image as Uint8List);
                                          database.saveArtistImage(
                                              artists[index].id, image);
                                        }
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: const Text(
                                        "Edit image",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ]))
                          ]);
                    }
                  },
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ExtractArgumentsArtistAlbums.routeName,
                        arguments: artists[index],
                      );
                    },
                    icon: Card(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: artists[index].image,
                          width: size.width / ncols - 31,
                          height: size.width / ncols - 31,
                        ),
                        Text(
                          ' ' + artists[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )),
                  ));
            }));
      },
    );
  }
}
