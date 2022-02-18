import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ShowQueue extends StatefulWidget {
  ShowQueue();

  @override
  State<ShowQueue> createState() => _ShowQueueState();
}

class _ShowQueueState extends State<ShowQueue> {
  List<Track> queue = [];

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    queue = trackQueue.queue;
    return Scaffold(
      appBar: AppBar(
        title:
            Row(
              children: [
                const Expanded(
                  child: Text("Queue"),
                ),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/select',
                          arguments: (List<Track> tracks, int index) {
                            trackQueue.pushLast(tracks[index]);
                          });
                      _update();
                    },
                ),
              ],
            ),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
                childAspectRatio: 7,
              ),
              controller: ScrollController(
                keepScrollOffset: true,
                initialScrollOffset: trackQueue.currentIndex.toDouble(),
              ),
              shrinkWrap: true,
              itemCount: trackQueue.length,
              itemBuilder: (context, index) {
                return Container(
                    decoration: const BoxDecoration(
                        border:
                        //Border.all(color: Colors.black, width: 0.05)),
                        Border(
                          top: BorderSide(width: 0.05, color: Colors.black),
                          bottom: BorderSide(width: 0.05, color: Colors.black),
                        )),


                    child: ListTile(

                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 20,
                            child: Text(
                                (index - trackQueue.currentIndex).toString(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                              height: 40,
                              child: queue[index].album.thumbnail,
                              width: 50,
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  queue[index].title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  queue[index].artist.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width - 130,
                          )

                        ],
                      ),

                      onTap: () async {
                        if (index != trackQueue.currentIndex) {
                          player.pause();
                          trackQueue.setCurrent(index);
                          player.play();
                        }
                        Navigator.pop(context);
                      },
                    )
                );
              }),
        ),
        PlayBar(),
      ]),

    );
  }
}
