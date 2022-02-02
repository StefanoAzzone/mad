import 'package:flutter/material.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';



class PorArtistCard extends StatefulWidget {
  Artist artist;
  PorArtistCard(this.artist);
  @override
  State<PorArtistCard> createState() => _PorArtistCardState(artist);
}

class _PorArtistCardState extends State<PorArtistCard> {
  Artist artist;
  _PorArtistCardState(this.artist);

  build(context) {
    Size size = MediaQuery.of(context).size;
    
    return OrientationBuilder(
      builder: (context, orientation) {
        return GestureDetector(
          child:
            Row(
              children: [
                SizedBox(
                  width: size.width/20,
                  height: size.height/3,
                ),
                SizedBox(
                  child: artist.image,
                  width: size.width/3,
                  height: size.height/4,
                ),
                SizedBox(
                  width: size.width/20,
                  height: size.height/3,
                ),
                Column(
                  children: [
                    SizedBox(
                      // width: (orientation == Orientation.portrait) ? size.width/2 : size.width/2,
                      // height: (orientation == Orientation.portrait) ? size.height/100 : size.height/2,
                      width: size.width/2,  
                      height: size.height/4,
                      child: 
                          FutureBuilder(
                            future: loader.getWikipedia(artist.name),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if(snapshot.hasData) {
                                return Center(
                                  child:
                                    Text(
                                      snapshot.data!,
                                      style: TextStyle(overflow: TextOverflow.fade),
                                    )
                                );
                              } else if(snapshot.connectionState == ConnectionState.waiting) {
                                return
                                Center(
                                  child: 
                                    SizedBox(
                                      child: CircularProgressIndicator(),
                                      width: size.width/10,
                                      //height: size.height/10,
                                    )
                                ); 
                              } else {
                                return Text("Couldn't find anything on Wikipedia...");
                              }
                            },
                          ),
                    )
                  ],
                )
              ],
            ),
            onTap: () async {
              Navigator.pushNamed(
                context, "/artistInfo",
                arguments: artist.name
              );
            },
        );

      }
    );
  }

}