import 'package:flutter/material.dart';
import 'package:mad/data.dart';

class AlbumCard extends StatefulWidget {
  final int ncols;
  final Album album;
  const AlbumCard(this.album, this.ncols, {Key? key}) : super(key: key);
  @override
  State<AlbumCard> createState() => _AlbumCardState();


}
class _AlbumCardState extends State<AlbumCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SizedBox(
                  child: widget.album.cover,
                  width: size.width / widget.ncols - 20,
                  height: size.width / widget.ncols - 20,
                ),
            ),
            Text(
              ' ' + widget.album.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,

              ),
            ),
            Text(
              ' ' + widget.album.artist.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 12,

              ),
            ),
          ],
        )
    );
  }
}