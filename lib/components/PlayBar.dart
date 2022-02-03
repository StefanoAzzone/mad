import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlayBar extends StatefulWidget {
  @override
  State<PlayBar> createState() => _PlayBarState();
}

  // static final PlayBar instance = PlayBar._internal();
  // factory PlayBar() {
  //   return instance;
  // }
  // PlayBar._internal();

class _PlayBarState extends State<PlayBar> {
  _PlayBarState() {
    player.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: 
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Row(
                      children: [
                        SizedBox(
                          width: size.width*0.15,
                          height: 50,
                          child: trackQueue.length > 0 ? trackQueue.current().album.cover : defaultImage,
                        ),
                        SizedBox(
                          width: size.width*0.01,
                          height: 50,
                        ),
                        SizedBox(
                          width: size.width*0.65,
                          height: 50,
                          child: Column(children: () {
                            if(trackQueue.length > 0) {
                              return 
                                [
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
                                    style: const TextStyle(
                                      fontSize: 12
                                    ),
                                  )
                                ];
                            } else return [
                              Center(
                                child: Text("Nothing in queue"),
                              )
                              
                            ];
                          }()
                        ))

                      ]
                    ),
                    onPressed: () {
                      if(trackQueue.length > 0) {
                        Navigator.pushNamed(context, '/playingTrack'); 
                      }
                    },

                  )
                ),
                () {
                  if(trackQueue.length > 0) {
                    return PlayButton();

                  }
                  else return SizedBox.shrink();
                } (),
                
              ],
            )
        )
      );

  }
}
