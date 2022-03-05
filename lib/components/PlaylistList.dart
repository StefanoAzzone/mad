import 'package:flutter/material.dart';

import 'package:mad/data.dart';

class PlaylistList extends StatefulWidget {
  @override
  State<PlaylistList> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  List<Playlist> playlists = database.playlists;
  String newName = "";
  TextEditingController tec = TextEditingController();
  late Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            body: GridView.count(
              padding: EdgeInsets.only(top: 0.0),
              childAspectRatio: 7,
              crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
              shrinkWrap: true,
              children: List.generate(playlists.length, (index) {
                return Container(
                  decoration: const BoxDecoration(
                      border:
                      //Border.all(color: Colors.black, width: 0.05)),
                      Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey),
                        left: BorderSide(width: 0.5, color: Colors.grey),
                      )),
                  child: GestureDetector(
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
                                            Navigator.pop(context);
                                            database.playlists.removeAt(index);
                                            setState(() {});
                                          },
                                          child: const Text(
                                            "Delete playlist",
                                            style: TextStyle(color: Colors.black),
                                          )),
                                    ]))
                              ]);
                        }
                      },
                      child: ListTile(
                        title: Text(
                          playlists[index].name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/showPlaylist',
                              arguments: playlists[index]);
                        },
                      )
                  )
                );

              }),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('New playlist'),
                          content: TextFormField(
                            controller: tec,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Playlist name',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  database.insertPlaylist(Playlist(tec.text));
                                });
                                await database.saveAllData();
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                }));
      },
    );
  }
}
