import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/bar/ProgressBar.dart';
import 'package:mad/buttons/CoverButton.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'package:mad/data.dart';

class PlayingTrack extends StatelessWidget {
  PlayingTrack();

  @override
  Widget build(BuildContext context) {
    var body = [
                Expanded(child: CoverButton()),
                Expanded(child: Column(
                  children: [
                    Expanded(child: ProgressBar()),
                    Expanded(child: Row(
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
                    )
                  ],
                ))
            ];
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            appBar: AppBar(
              title: Text(trackQueue.current().title +
                  " - " +
                  trackQueue.current().artist.name),
              centerTitle: true,
            ),
            
            body: (){
              if(orientation == Orientation.portrait) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: body
                );
              } else {
              return Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: body
                );
              }
            }() 
        );
      },
    );
    
  }
}
