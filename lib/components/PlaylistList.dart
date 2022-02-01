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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            body: GridView.count(
                padding: EdgeInsets.only(top: 0.0),
                childAspectRatio: 10,
                crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                shrinkWrap: true,
                children: List.generate(playlists.length, (index) {
                  return ListTile(
                    title: Text(
                      playlists[index].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/showPlaylist',
                          arguments: playlists[index]);
                    },
                  );
                }),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                              onPressed: () {
                                setState(() {
                                  database.createPlaylist(tec.text);
                                });
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
