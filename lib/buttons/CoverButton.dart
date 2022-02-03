import 'dart:typed_data';
import 'dart:ui';

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
    return  SafeArea(
      child: 
        OrientationBuilder(
          builder: (context, orientation) {
            return GestureDetector(
                  child: SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: (() {
                      if (lyricsVisible) {
                        return Stack(
                          children: [
                            Center(
                              child: Container(
                                height: size.height/2,
                                decoration: BoxDecoration(
                                  //color: Colors.grey,
                                  image: DecorationImage(image: trackQueue.current().album.cover.image),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                        child: Container(
                                          
                                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                                        ),
                                      ),
                                )
                              )
                              
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Center(
                              child: Container(
                                  height: size.height/1.7,
                                  child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          trackQueue.current().lyrics,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ),
                                )
                            )
                            
                          ],
                        );
                      }
                      return trackQueue.current().album.cover;
                    }()),
                  ),
                  onTap: (() => setState(() {
                        lyricsVisible = !lyricsVisible;
                      })),
            );
          }
        )
    
    );
  }
}
