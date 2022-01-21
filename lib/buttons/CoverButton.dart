import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'dart:io';

import 'package:mad/data.dart';

class CoverButton extends StatefulWidget {
  @override
  State<CoverButton> createState() => _CoverButtonState();
}

class _CoverButtonState extends State<CoverButton> {
  bool lyricsVisible = false;
  double imageSize = 100;

  _CoverButtonState() {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    imageSize = size.width < size.height
        ? (size.width / 100 * 95)
        : (size.height / 100 * 95);
    return Expanded(
        child: IconButton(
            iconSize: imageSize,
            onPressed: () {
              setState(() {
                lyricsVisible = !lyricsVisible;
              });
            },
            icon: (() {
              return trackQueue.current().album.cover;
            }())));
  }
}
