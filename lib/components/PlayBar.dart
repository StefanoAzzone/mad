import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

class PlayBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (trackQueue.length > 0) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Text(trackQueue.current().title),
              ),
              IconButton(
                alignment: Alignment.bottomRight,
                color: Colors.deepPurple,
                onPressed: () {
                  player.play();
                  print("I'm singing in the rain!!!");
                },
                icon: Icon(Icons.play_arrow),
              ),
            ],
          ));
    }
    return SizedBox.shrink();
  }
}
