import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ShowQueue extends StatefulWidget {
  const ShowQueue({Key? key}) : super(key: key);

  @override
  State<ShowQueue> createState() => _ShowQueueState();
}

class _ShowQueueState extends State<ShowQueue> {
  final int MAX_SWIPE_OFFSET = 200;
  final int SWIPE_TRESHOLD = 1;
  List<Track> queue = [];
  double offset = 0.0;
  int lastSwipeIndex = 0;
  late int token;

  _ShowQueueState() {
    token = player.subscribe(() {
      setState(() {});
    });
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    player.unsubscribe(token);
  }

  @override
  Widget build(BuildContext context) {
    queue = trackQueue.queue;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.indigo, Colors.lightBlue])),
        ),
        title: Row(
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
                setState(() {});
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
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 1
                        : 2,
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
                    child: GestureDetector(
                        onPanUpdate: (details) {
                          double dx = details.delta.dx;
                          if (dx >= SWIPE_TRESHOLD && lastSwipeIndex >= 0) {
                            // swiping in right direction
                            setState(() {
                              offset += dx;
                              if (offset >= MAX_SWIPE_OFFSET) {
                                offset = 0;
                                if (index == trackQueue.currentIndex) {
                                  player.next();
                                }
                                trackQueue.remove(index);
                                lastSwipeIndex = -1;
                              } else {
                                lastSwipeIndex = index;
                              }
                            });
                          } else if (dx < 0) {
                            dx = -dx;
                            setState(() {
                              offset = offset > dx ? offset - dx : 0;
                            });
                          }
                        },
                        onPanEnd: (details) => setState(() {
                              offset = 0;
                              lastSwipeIndex = 0;
                            }),
                        child: ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 50,
                                width: index == lastSwipeIndex ? offset : 0,
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                width: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? MediaQuery.of(context).size.width -
                                        130 -
                                        (lastSwipeIndex == index ? offset : 0)
                                    : MediaQuery.of(context).size.width / 2 -
                                        110 -
                                        (lastSwipeIndex == index ? offset : 0),
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
                        )));
              }),
        ),
        const PlayBar(),
      ]),
    );
  }
}
