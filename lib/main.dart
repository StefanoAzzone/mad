import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mad/data.dart';
import 'package:mad/screens/Home.dart';
import 'package:mad/screens/PlayingTrack.dart';

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
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
