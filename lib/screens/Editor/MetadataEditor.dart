import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class MetadataEditor extends StatefulWidget {
  @override
  State<MetadataEditor> createState() => _MetadataEditorState();
}

class _MetadataEditorState extends State<MetadataEditor> {
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.indigo, Colors.lightBlue])),
          ),
          title: TextFormField(
            onChanged: (value) async {
              var res = await loader.searchAllTracks(value);
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: loader.getItemsCount(result),
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: loader.extractThumbnailUrlFromTracks(result, index),
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
                        Uint8List? thumbnail = snapshot.data as Uint8List?;
                        return ListTile(
                          title: Container(
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              children: [
                                thumbnail == null
                                    ? defaultAlbumThumbnail
                                    : Image.memory(thumbnail),
                                Padding(padding: EdgeInsets.all(8)),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: size.height / 15,
                                        width: size.width - 112,
                                        child: Center(
                                          child: Text(
                                            loader.extractTitleFromTracks(
                                                result, index),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.fade,
                                          ),
                                        )),
                                    SizedBox(
                                      height: size.height / 25,
                                      width: size.width - 112,
                                      child: Center(
                                        child: Text(
                                          loader.extractArtistFromTracks(
                                              result, index),
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(
                                context, loader.getItem(result, index));
                          },
                        );
                      }
                    });
              },
            ),
          )
        ]));
  }
}
