import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/bar/ProgressBar.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class PlayingTrack extends StatefulWidget {
  const PlayingTrack({Key? key}) : super(key: key);

  @override
  State<PlayingTrack> createState() => _PlayingTrackState();
}

class _PlayingTrackState extends State<PlayingTrack> {
  late StreamSubscription<Duration> sub;

  _PlayingTrackState() {
    sub = player.audioPlayer.onDurationChanged.listen((event) {
      setState(() {});
    });
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(body: () {
          if (orientation == Orientation.portrait) {
            return SafeArea(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
              Text(
                trackQueue.current().title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                trackQueue.current().artist.name,
                style: const TextStyle(fontSize: 12),
              ),
              Expanded(child: CoverButton()),
              Column(
                children: [
                  const ProgressBar(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await loader.checkConnection();
                              Navigator.pushNamed(context, "/artistInfo",
                                  arguments: trackQueue.current().artist.name);
                            },
                            icon: const Icon(Icons.art_track)),
                        IconButton(
                            onPressed: () {
                              player.prev();
                              setState(() {});
                            },
                            icon: const Icon(Icons.skip_previous_rounded)),
                        const PlayButton(),
                        IconButton(
                            onPressed: () {
                              player.next();
                              setState(() {});
                            },
                            icon: const Icon(Icons.skip_next_rounded)),
                        IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/queue');
                              if (trackQueue.length <= 0) {
                                Navigator.pop(context);
                              } else {
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.view_list)),
                      ])
                ],
              )
            ]));
          } else {
            return SafeArea(
                child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  const Expanded(child: CoverButton()),
                  Expanded(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: SizedBox(
                              height: 50,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              return;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                      Text(
                        trackQueue.current().title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        trackQueue.current().artist.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Expanded(child: ProgressBar()),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await loader.checkConnection();
                                  Navigator.pushNamed(context, "/artistInfo",
                                      arguments:
                                          trackQueue.current().artist.name);
                                },
                                icon: const Icon(Icons.art_track)),
                            IconButton(
                                onPressed: () {
                                  player.prev();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.skip_previous_rounded)),
                            const PlayButton(),
                            IconButton(
                                onPressed: () {
                                  player.next();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.skip_next_rounded)),
                            IconButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(context, '/queue');
                                  setState(() {});
                                },
                                icon: const Icon(Icons.view_list)),
                          ])
                    ],
                  ))
                ]));
          }
        }());
      },
    );
  }
}
