import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:mad/data.dart';

class CoverButton extends StatefulWidget {
  @override
  State<CoverButton> createState() => _CoverButtonState();
}

class _CoverButtonState extends State<CoverButton> {
  static bool lyricsVisible = false;
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
                                height: MediaQuery.of(context).orientation == Orientation.portrait ? size.height/2 : size.height,
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
                                  height: MediaQuery.of(context).orientation == Orientation.portrait ? size.height/1.7 : size.height,
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
