import 'dart:collection';

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
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(onChanged: (value) async {
            var res = await loader.searchAllTracks(value);
            setState(() {
              result = res;
            });
          }),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: loader.getItemsCount(result),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                    child: Row(
                      children: [
                        loader.extractThumbnailUrlFromTracks(result, index),
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
                            Text(
                              loader.extractArtistFromTracks(result, index),
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
          )
        ]));
  }
}
