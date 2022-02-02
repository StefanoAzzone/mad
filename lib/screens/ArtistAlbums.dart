import 'package:flutter/material.dart';
import 'package:mad/buttons/LanArtistCard.dart';
import 'package:mad/buttons/PorArtistCard.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatelessWidget {
  Artist artist;
  ArtistAlbums(this.artist);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.portrait) print('por');
        else print('lan');
        return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverSafeArea(
                    sliver:
                      SliverAppBar(  
                        backgroundColor: Colors.lightBlue[100],
                        expandedHeight: 200,
                        flexibleSpace: FlexibleSpaceBar(

                              background: (){
                                if(orientation == Orientation.portrait) {
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
              body: 

                    Column(children: [
                      Expanded(
                        child: AlbumList(artist.albumList),
                      ),
                      PlayBar(),
                    ])
            )
          );

      }
    );
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
