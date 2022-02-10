import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/bar/ProgressBar.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';



class PlayingTrack extends StatefulWidget {
  @override
  State<PlayingTrack> createState() => _PlayingTrackState();
}

class _PlayingTrackState extends State<PlayingTrack> {
  _PlayingTrackState() {
    player.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            
            body: (){
              if(orientation == Orientation.portrait) {
                return SafeArea(
                  child:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 50,),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            return;
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ),
                    Text(trackQueue.current().title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25,),
                    Text(
                      trackQueue.current().artist.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                Expanded(child: CoverButton()),
                Column(
                  children: [
                    ProgressBar(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/artistInfo",
                                  arguments: trackQueue.current().artist.name);
                            },
                            icon: const Icon(Icons.art_track)),
                        IconButton(
                            onPressed: (){
                              player.prev();
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.skip_previous_rounded)),
                        PlayButton(),
                        IconButton(
                            onPressed: () {
                              player.next();
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.skip_next_rounded)),
                        IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/queue');
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.view_list)),
                      ]
                    )
                    
                  ],
                )
            ]
                )
                );
              } else {
              return SafeArea(
                child: 
               Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Expanded(child: CoverButton()),
                Expanded(child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: SizedBox(height: 50,),),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            return;
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ),
                    Text(trackQueue.current().title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25,),
                    Text(
                      trackQueue.current().artist.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Expanded(child: ProgressBar()),
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/artistInfo",
                                  arguments: trackQueue.current().artist.name);
                            },
                            icon: const Icon(Icons.art_track)),
                        IconButton(
                            onPressed: () {
                              player.prev();
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.skip_previous_rounded)),
                        PlayButton(),
                        IconButton(
                            onPressed: () {
                              player.next();
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.skip_next_rounded)),
                        IconButton(
                            onPressed: () async {
                               await Navigator.pushNamed(context, '/queue');
                              setState(() {
                                
                              });
                            },
                            icon: const Icon(Icons.view_list)),
                      ]
                    )
                    
                  ],
                ))
            ]
                )
              );
              }
            }() 
        );
      },
    );
    
  }
}
