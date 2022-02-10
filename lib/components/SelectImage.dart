import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mad/Player.dart';
import 'package:mad/data.dart';

class SelectImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(),
      Container(
        child: ShrinkWrappingViewport(offset: ViewportOffset.zero(), slivers: [
          // SliverGrid.count(
          //     crossAxisCount: 2,
          //     children: List.generate(4, (index) {
          //       return IconButton(
          //           onPressed: () => print(index),
          //           icon: Expanded(child: defaultImage));
          //     }))
        ]),
      )
    ]);
  }
}
