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

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

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

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.indigo, Colors.lightBlue])),
          ),
          title: SizedBox(
            height: 40,
            child: TextFormField(
              onChanged: (value) async {
                var res = await loader.searchAllTracks(value);
                setState(() {
                  result = res;
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: "Enter Name",
                labelStyle: const TextStyle(
                  color: Colors.blue,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.lightBlue.shade50,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide: const BorderSide(
                    color: Colors.lightBlue,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide: const BorderSide(
                    color: Colors.lightBlue,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                childAspectRatio: 6.5,
              ),
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
                            decoration: const BoxDecoration(
                                border: Border(
                              top: BorderSide(width: 0.05, color: Colors.black),
                              bottom:
                                  BorderSide(width: 0.05, color: Colors.black),
                            )),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: thumbnail == null
                                      ? defaultAlbumThumbnail
                                      : Image.memory(thumbnail),
                                ),
                                const Padding(padding: EdgeInsets.all(8)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: orientation == Orientation.portrait
                                          ? size.width * 0.7
                                          : size.width * 0.29,
                                      child: Text(
                                        loader.extractTitleFromTracks(
                                            result, index),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: orientation == Orientation.portrait
                                          ? size.width * 0.7
                                          : size.width * 0.29,
                                      child: Text(
                                        loader.extractArtistFromTracks(
                                            result, index),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
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
