import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/PlayButton.dart';

import 'package:mad/data.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({Key? key}) : super(key: key);

  @override
  State<PlayBar> createState() => _PlayBarState();
}

// static final PlayBar instance = PlayBar._internal();
// factory PlayBar() {
//   return instance;
// }
// PlayBar._internal();

class _PlayBarState extends State<PlayBar> {
  late int token;

  _PlayBarState() {
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
    Size size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black54)),
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                  icon: Row(children: [
                    SizedBox(
                      width: size.width * 0.15,
                      height: 50,
                      child: trackQueue.length > 0
                          ? trackQueue.current().album.cover
                          : defaultImage,
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                      height: 50,
                    ),
                    SizedBox(
                        width: size.width * 0.65,
                        height: 50,
                        child: Column(children: () {
                          if (trackQueue.length > 0) {
                            return [
                              Text(
                                trackQueue.current().title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                trackQueue.current().artist.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              )
                            ];
                          } else {
                            return [
                              const Center(
                                child: Text("Nothing in queue"),
                              )
                            ];
                          }
                        }()))
                  ]),
                  onPressed: () async {
                    if (trackQueue.length > 0) {
                      await Navigator.pushNamed(context, '/playingTrack');
                      setState(() {});
                    }
                  },
                )),
                () {
                  if (trackQueue.length > 0) {
                    return const PlayButton();
                  } else {
                    return const SizedBox.shrink();
                  }
                }(),
              ],
            )));
  }
}
