import 'package:flutter/material.dart';
import 'package:mad/Player.dart';
import 'package:mad/components/AlbumList.dart';
import 'package:mad/components/PlayBar.dart';
import 'package:mad/components/TrackList.dart';
import 'package:mad/data.dart';

class ArtistAlbums extends StatelessWidget {
  Artist artist;
  ArtistAlbums(this.artist);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(artist.name),
          centerTitle: true,
        ),
        body: Column(children: [
          Row(
            children: [
              SizedBox(
                width: size.width/20,
                height: size.height/3,
              ),
              SizedBox(
                child: artist.image,
                width: size.width/2,
                height: size.height/3,
              ),
              SizedBox(
                width: size.width/20,
                height: size.height/3,
              ),
              Column(
                children: [
                  SizedBox(
                    width: size.width/3 ,
                    height: size.height/15 ,
                    child: 
                      Text(
                        artist.name,
                        style: TextStyle(fontSize: 20),
                        //overflow: TextOverflow.ellipsis,
                      )
                    
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: AlbumList(artist.albumList),
          ),
          PlayBar(),
        ]));
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
