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
  @override
  State<ArtistEditor> createState() => _ArtistEditorState();
}

class _ArtistEditorState extends State<ArtistEditor> {
  final int MAX_IMAGES = 12;
  var result;
  Size size = Size.zero;

  @override
  Widget build(BuildContext context) {
    if (!loader.connected) {
      return const Center(
        child: Text(
            "Cannot access server.\nTry to check your internet connection."),
      );
    }
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            onChanged: (value) async {
              var res = await loader.searchAllArtists(value);
              setState(() {
                result = res;
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
        body: Column(children: [
          Expanded(
              child: GridView.count(
            childAspectRatio: 1,
            padding: EdgeInsets.only(top: 0.0),
            crossAxisCount: 2,
            shrinkWrap: true,
            children: List.generate(
              loader.getItemsCount(result) <= MAX_IMAGES
                  ? loader.getItemsCount(result)
                  : MAX_IMAGES,
              (index) {
                return FutureBuilder(
                    future: loader.getArtistImage(
                        loader.extractId(loader.getItem(result, index))),
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
        ]));
  }
}
