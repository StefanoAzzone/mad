import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mad/data.dart';
import 'package:mad/screens/Home.dart';
import 'package:mad/screens/MetadataEditor.dart';
import 'package:mad/screens/PlayingTrack.dart';
import 'package:mad/screens/SelectTracks.dart';
import 'package:mad/screens/ShowQueue.dart';

void main() {
  //Database.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBox',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'MBox'),
        '/playingTrack': (context) => PlayingTrack(),
        '/queue': (context) => ShowQueue(),
        '/select': (context) => SelectTracks(),
        '/editMetadata': (context) => MetadataEditor(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
