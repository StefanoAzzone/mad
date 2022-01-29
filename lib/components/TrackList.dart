import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:path_provider/path_provider.dart';

class TrackList extends StatefulWidget {
  Function callback;
  List<Track> list;
  TrackList(this.callback, this.list);
  @override
  State<TrackList> createState() => _TrackListState(callback, list);
}

class _TrackListState extends State<TrackList> {
  Function callback;
  List<Track> tracks;
  var _tapPosition;

  _TrackListState(this.callback, this.tracks);

  @override
  Widget build(BuildContext context) {
    int count = database.state == DatabaseState.Ready
        ? tracks.length
        : tracks.length + 1;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          RenderObject? overlay =
              Overlay.of(context)?.context.findRenderObject();
          if (index == tracks.length) {
            Size size = MediaQuery.of(context).size;
            return Center(
                child: SizedBox(
                    width: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    height: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    )));
          }
          return GestureDetector(
              onTapDown: (TapDownDetails details) {
                _tapPosition = details.globalPosition;
              },
              onLongPress: () {
                Size? size = overlay?.semanticBounds.size;
                if (size != null) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                        _tapPosition &
                            const Size(40, 40), // smaller rect, the touch area
                        Offset.zero & size // Bigger rect, the entire screen
                        ),
                    items: <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: 'Value1',
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var metadata = await Navigator.pushNamed(
                                        context, '/editMetadata');
                                    if (metadata != null) {
                                      await database.setNewMetadata(
                                          tracks[index], metadata);
                                      setState(() {
                                        //tracks = database.tracks;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Edit metadata",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    trackQueue.pushLast(tracks[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Add to queue",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ],
                          )),
                    ],
                  );
                }
              },
              child: ListTile(
                title: Text(
                    tracks[index].title + " - " + tracks[index].artist.name),
                onTap: () {
                  print(tracks[index].title);
                  callback(tracks[index]);
                },
              ));
        });
  }
}
