import 'package:flutter/material.dart';
import 'package:mad/buttons/ArtistCard.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatefulWidget {
  final Artist artist;
  const ArtistAlbums(this.artist, {Key? key}) : super(key: key);
  @override
  State<ArtistAlbums> createState() => _ArtistAlbumsState();
}

class _ArtistAlbumsState extends State<ArtistAlbums> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.artist.name),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.indigo, Colors.lightBlue])),
            ),
          ),
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverSafeArea(
                    sliver: SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.lightBlue[100],
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(background: () {
                        return ArtistCard(widget.artist);
                      }()),
                    ),
                  )
                ];
              },
              body: Column(children: [
                Expanded(
                  child: AlbumList(widget.artist.albumList),
                ),
              ])),
          bottomNavigationBar: const BottomAppBar(
              child: SizedBox(
            child: PlayBar(),
            height: 50,
          )));
    });
  }
}

class ExtractArgumentsArtistAlbums extends StatelessWidget {
  const ExtractArgumentsArtistAlbums({Key? key}) : super(key: key);

  static const routeName = '/artistAlbums';

  @override
  Widget build(BuildContext context) {
    final artist = ModalRoute.of(context)!.settings.arguments as Artist;

    return ArtistAlbums(artist);
  }
}
