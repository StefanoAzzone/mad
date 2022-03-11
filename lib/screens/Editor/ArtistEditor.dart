import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class ArtistEditor extends StatefulWidget {
  String artistName;
  ArtistEditor(this.artistName);

  @override
  State<ArtistEditor> createState() => _ArtistEditorState(artistName);
}

class _ArtistEditorState extends State<ArtistEditor> {
  final int MAX_IMAGES = 10;
  Size size = Size.zero;
  String artistName;
  Timer timer = Timer(Duration.zero, () => 0);

  _ArtistEditorState(this.artistName);

  @override
  Widget build(BuildContext context) {
    if (!loader.connected) {
      return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.indigo, Colors.lightBlue])),
            ),
          ),
          body: Center(
            child: Text(
                "Cannot access server.\nTry to check your internet connection."),
          ));
    }

    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.indigo, Colors.lightBlue])),
          ),
          title: TextFormField(
            initialValue: artistName,
            onChanged: (value) {
              timer.cancel();
              timer = Timer(Duration(milliseconds: 500), () {
                print("updated");
                setState(() {
                  artistName = value;
                });
              });
            },
            decoration: InputDecoration(
              labelText: "Enter Name",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Colors.lightBlue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Colors.lightBlue,
                  width: 3.0,
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: loader.searchAllArtists(artistName),
          builder: (context, altSnapshot) {
            if (!altSnapshot.hasData) {
              return const Center(child: Text("No artist found."));
            }
            return Column(children: [
              Expanded(
                  child: GridView.count(
                childAspectRatio: 1,
                padding: EdgeInsets.only(top: 0.0),
                crossAxisCount: 2,
                shrinkWrap: true,
                children: List.generate(
                  loader.getItemsCount(altSnapshot.data) <= MAX_IMAGES
                      ? loader.getItemsCount(altSnapshot.data)
                      : MAX_IMAGES,
                  (index) {
                    return FutureBuilder(
                        future: loader.getArtistImage(loader.extractId(
                            loader.getItem(altSnapshot.data, index))),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: SizedBox(
                              //TODO FIX
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            Uint8List? image = snapshot.data as Uint8List?;
                            return ListTile(
                              title: Container(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey[200],
                                child: image == null
                                    ? defaultImage
                                    : Image.memory(image),
                              ),
                              onTap: () {
                                Navigator.pop(context, image);
                              },
                            );
                          }
                        });
                  },
                ),
              ))
            ]);
          },
        ));
  }
}

class ExtractArgumentsArtistEditor extends StatelessWidget {
  const ExtractArgumentsArtistEditor({Key? key}) : super(key: key);

  static const routeName = '/artistEditor';

  @override
  Widget build(BuildContext context) {
    final artistName = ModalRoute.of(context)!.settings.arguments;

    return ArtistEditor(artistName as String);
  }
}
