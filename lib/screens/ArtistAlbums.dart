import 'package:flutter/material.dart';
import 'package:mad/buttons/LanArtistCard.dart';
import 'package:mad/buttons/PorArtistCard.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatefulWidget {
  Function updateHome;
  Artist artist;
  ArtistAlbums(this.artist, this.updateHome);
  @override
  State<ArtistAlbums> createState() => _ArtistAlbumsState(artist, updateHome);
}

class _ArtistAlbumsState extends State<ArtistAlbums> {
  Function updateHome;
  Artist artist;
  _ArtistAlbumsState(this.artist, this.updateHome);

  _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverSafeArea(
                    sliver: SliverAppBar(
                      backgroundColor: Colors.lightBlue[100],
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(background: () {
                        if (orientation == Orientation.portrait) {
                          return PorArtistCard(artist);
                        } else {
                          return LanArtistCard(artist);
                        }
                      }()
                          //
                          ),
                    ),
                  )
                ];
              },
              body: Column(children: [
                Expanded(
                  child: AlbumList(artist.albumList, () {
                    updateHome;
                    _update();
                  }),
                ),
              ])),
          bottomNavigationBar: BottomAppBar(
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
    final args =
        ModalRoute.of(context)!.settings.arguments as ArtistAlbumsArguments;

    return ArtistAlbums(args.artist, args.updateHome);
  }
}

class ArtistAlbumsArguments {
  final Artist artist;
  final Function updateHome;

  ArtistAlbumsArguments(this.artist, this.updateHome);
}
