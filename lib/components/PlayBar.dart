import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/PlayButton.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlayBar extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (trackQueue.length > 0) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: size.width*0.15,
                        height: 50,
                        child: trackQueue.current().album.cover,
                      ),
                      const SizedBox(
                        width: 10,
                        height: 50,
                      ),
                        Text(trackQueue.current().title),

                    ]
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/playingTrack');
                  },

                )
              ),
              PlayButton(),
            ],
          ));
    }
    return SizedBox.shrink();
  }
}
