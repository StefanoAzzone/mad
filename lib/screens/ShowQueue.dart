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
    queue = trackQueue.queue;
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue"),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              controller: ScrollController(
                keepScrollOffset: true,
                initialScrollOffset: trackQueue.currentIndex.toDouble(),
              ),
              shrinkWrap: true,
              itemCount: trackQueue.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      (index - trackQueue.currentIndex).toString() + ". " + queue[index].title + " - " + queue[index].artist.name),
                  onTap: () async {
                    if (index != trackQueue.currentIndex) {
                      player.pause();
                      trackQueue.setCurrent(index);
                      player.play();
                    }
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, '/select',
                arguments: (List<Track> tracks, int index) {
              trackQueue.pushLast(tracks[index]);
            });
            _update();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            child: PlayBar(),
            height: 70,
          )),
    );
  }
}
