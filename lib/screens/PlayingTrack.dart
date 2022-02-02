import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/bar/ProgressBar.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';



class PlayingTrack extends StatefulWidget {
  //PlayingTrack();
  
  @override
  State<PlayingTrack> createState() => _PlayingTrackState();
}

class _PlayingTrackState extends State<PlayingTrack> {

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
                    SizedBox(height: 50,),
                    Text(trackQueue.current().title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25,),
                    Text(
                      trackQueue.current().artist.name,
                      style: TextStyle(fontSize: 12),
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
                            icon: Icon(Icons.ramen_dining)),
                        IconButton(
                            onPressed: () => (print("prev")),
                            icon: Icon(Icons.skip_previous_rounded)),
                        PlayButton(),
                        IconButton(
                            onPressed: () => (print("next")),
                            icon: Icon(Icons.skip_next_rounded)),
                        IconButton(
                            onPressed: () {
                              print("queue");
                              Navigator.pushNamed(context, '/queue');
                            },
                            icon: Icon(Icons.view_list)),
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
                    SizedBox(height: 50,),
                    Text(trackQueue.current().title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25,),
                    Text(
                      trackQueue.current().artist.name,
                      style: TextStyle(fontSize: 12),
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
                            icon: Icon(Icons.ramen_dining)),
                        IconButton(
                            onPressed: () {
                              player.prev();
                              setState(() {
                                
                              });
                            },
                            icon: Icon(Icons.skip_previous_rounded)),
                        PlayButton(),
                        IconButton(
                            onPressed: () {
                              player.next();
                              setState(() {
                                
                              });
                            },
                            icon: Icon(Icons.skip_next_rounded)),
                        IconButton(
                            onPressed: () {
                              print("queue");
                              Navigator.pushNamed(context, '/queue');
                            },
                            icon: Icon(Icons.view_list)),
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
