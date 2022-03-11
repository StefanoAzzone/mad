import 'package:flutter/material.dart';
import 'package:mad/data.dart';

class AlbumCard extends StatefulWidget {
  int ncols;
  Album album;
  AlbumCard(this.album, this.ncols, {Key? key}) : super(key: key);
  @override
  State<AlbumCard> createState() => _AlbumCardState(album, ncols);


}
class _AlbumCardState extends State<AlbumCard> {
  int ncols;
  Album album;
  _AlbumCardState(this.album, this.ncols);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SizedBox(
                  child: album.cover,
                  width: size.width / ncols - 20,
                  height: size.width / ncols - 20,
                ),
            ),
            Text(
              ' ' + album.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,

              ),
            ),
            Text(
              ' ' + album.artist.name,
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