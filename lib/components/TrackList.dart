import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mad/data.dart';
import 'package:path_provider/path_provider.dart';

class TrackList extends StatefulWidget {
  Function callback;
  TrackList(Function this.callback);  
    @override
  State<TrackList> createState() => _TrackListState(callback);
}

class _TrackListState extends State<TrackList> {
  Function callback;
  var _tapPosition;

  _TrackListState(this.callback);
  List<Track> tracks = Database.instance.tracks;

  @override
  Widget build(BuildContext context) {
    int count = database.state == DatabaseState.Ready
        ? tracks.length
        : tracks.length + 1;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          RenderObject? overlay = Overlay.of(context)?.context.findRenderObject();
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
            onTapDown: (TapDownDetails details){
              _tapPosition = details.globalPosition;
            },
            onLongPress: () {
      
              Size? size = overlay?.semanticBounds.size;
              if(size != null) {
                showMenu(context: context, 
                        position: RelativeRect.fromRect(
                        _tapPosition & const Size(40, 40), // smaller rect, the touch area
                        Offset.zero & size  // Bigger rect, the entire screen
                        ),
                        items: <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Value1',
                                  child: Text('Choose value 1'),
                                ),
                              ],);
              }
            },
            child: ListTile(
              title:
                  Text(tracks[index].title + " - " + tracks[index].artist.name),
              onTap: () {
                print(tracks[index].title);
                callback(tracks[index]);
              },
            )

          ); 
        });
  }

}
