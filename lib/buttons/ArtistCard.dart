import 'package:flutter/material.dart';
import 'package:mad/data.dart';
import 'package:mad/metadata_loader.dart';

class ArtistCard extends StatefulWidget {
  Artist artist;
  ArtistCard(this.artist, {Key? key}) : super(key: key);
  @override
  State<ArtistCard> createState() => _ArtistCardState(artist);
}

class _ArtistCardState extends State<ArtistCard> {
  Artist artist;
  _ArtistCardState(this.artist);

  @override
  build(context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      child: Row(
        children: [
          SizedBox(
            width: size.width / 20,
            height: size.height / 3,
          ),
          SizedBox(
            child: artist.image,
            width: size.width / 3,
            height: size.height / 4,
          ),
          SizedBox(
            width: size.width / 20,
            height: size.height / 3,
          ),
          Column(
            children: [
              SizedBox(
                width: (orientation == Orientation.portrait)
                    ? size.width / 2
                    : size.width / 2,
                height: (orientation == Orientation.portrait)
                    ? size.height / 4
                    : size.height / 2,
                child: FutureBuilder(
                  future: loader.getWikipedia(artist.name),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!loader.connected) {
                      return const Center(
                          child: Text(
                              "Cannot access server.\nTry to check your internet connection."));
                    } else if (snapshot.hasData) {
                      return Center(
                          child: Text(
                        snapshot.data!,
                        style: const TextStyle(overflow: TextOverflow.fade),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: SizedBox(
                        child: const CircularProgressIndicator(),
                        width: size.width / 10,
                        //height: size.height/10,
                      ));
                    } else {
                      return const Center(
                          child:
                              Text("Couldn't find anything on Wikipedia..."));
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
      onTap: () async {
        await loader.checkConnection();
        Navigator.pushNamed(context, "/artistInfo", arguments: artist.name);
      },
    );
  }
}
