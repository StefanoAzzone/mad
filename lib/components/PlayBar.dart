import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/buttons/PlayButton.dart';
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
              PlayButton(),
            ],
          ));
    }
    return SizedBox.shrink();
  }
}
