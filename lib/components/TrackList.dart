import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class TrackList extends StatefulWidget {
  final Function callback;
  final List<Track> tracks;
  final bool numbers;
  const TrackList(this.callback, this.tracks, this.numbers, {Key? key}) : super(key: key);
  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int count = database.state == DatabaseState.Ready
        ? widget.tracks.length + 1
        : widget.tracks.length + 2;
    var ncols =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2;

    if (widget.tracks.isEmpty) {
      return const Center(
        child: Text("No content here."),
      );
    }

    return GridView.count(
        padding: const EdgeInsets.only(top: 0.0),
        crossAxisCount: ncols,
        shrinkWrap: true,
        childAspectRatio: 6.5,
        children: List.generate(count, (index) {
          RenderObject? overlay =
              Overlay.of(context)?.context.findRenderObject();
          if (index >= widget.tracks.length + 1) {
            Size size = MediaQuery.of(context).size;
            return Center(
                child: SizedBox(
                    width: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    height: size.width < size.height
                        ? size.width / 10
                        : size.height / 10,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    )));
          }
          if (index <= 0) {
            return ListTile(
              title: InkWell(
                  onTap: () async {
                    trackQueue.reset();
                    trackQueue.addList(widget.tracks);
                    trackQueue.shuffle();
                    player.play();
                    await Navigator.pushNamed(context, '/playingTrack');
                    setState(() {});
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text("Shuffle"),
                          ),
                          Icon(Icons.shuffle),
                        ],
                      ))),
            );
          }
          return Container(
              decoration: const BoxDecoration(
                  border:
                      //Border.all(color: Colors.black, width: 0.05)),
                      Border(
                top: BorderSide(width: 0.05, color: Colors.black),
                bottom: BorderSide(width: 0.05, color: Colors.black),
              )),
              child: GestureDetector(
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
                                const Size(
                                    40, 40), // smaller rect, the touch area
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
                                        await loader.checkConnection();
                                        var metadata =
                                            await Navigator.pushNamed(
                                                context, '/editMetadata');
                                        if (metadata != null) {
                                          await database.setNewMetadata(
                                              widget.tracks[index - 1],
                                              metadata);
                                          setState(() {
                                            //tracks = database.tracks;
                                          });
                                        }
                                      },
                                      child: const Text(
                                        "Edit metadata",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        trackQueue
                                            .pushLast(widget.tracks[index - 1]);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Add to queue",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title: const Text(
                                                      'Add to playlist'),
                                                  content: SizedBox(
                                                    height: 500,
                                                    width: 500,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: database
                                                            .playlists.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return ListTile(
                                                            title: Text(database
                                                                .playlists[i]
                                                                .name),
                                                            onTap: () async {
                                                              database
                                                                  .playlists[i]
                                                                  .addTrack(widget
                                                                          .tracks[
                                                                      index -
                                                                          1]);
                                                              await database
                                                                  .saveAllData();
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        }),
                                                  ));
                                            });
                                      },
                                      child: const Text(
                                        "Add to playlist",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ],
                              )),
                        ],
                      );
                    }
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          (widget.numbers == true ? 
                                    widget.tracks[index - 1]
                                      .trackNumber.toString().padLeft(2, '0') : "")
                        ),
                        SizedBox(
                          width: size.width * 0.15,
                          height: 50,
                          child: widget.tracks[index - 1].album.thumbnail,
                        ),
                        const SizedBox(
                          height: 50,
                          width: 5,
                        ),
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? size.width * 0.7
                                : size.width * 0.29,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.tracks[index - 1].title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.tracks[index - 1].artist.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    onTap: () {
                      widget.callback(widget.tracks, index - 1);
                    },
                  )));
        }));
  }
}
