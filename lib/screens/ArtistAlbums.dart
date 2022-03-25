import 'package:flutter/material.dart';
import 'package:mad/buttons/ArtistCard.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatefulWidget {
  Artist artist;
  ArtistAlbums(this.artist, {Key? key}) : super(key: key);
  @override
  State<ArtistAlbums> createState() => _ArtistAlbumsState(artist);
}

class _ArtistAlbumsState extends State<ArtistAlbums> {
  Artist artist;
  _ArtistAlbumsState(this.artist);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            title: Text(artist.name),
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
                        return ArtistCard(artist);
                      }()),
                    ),
                  )
                ];
              },
              body: Column(children: [
                Expanded(
                  child: AlbumList(artist.albumList),
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
