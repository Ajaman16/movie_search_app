import 'package:flutter/material.dart';
import 'package:movie_search_app/src/models/movie_model.dart';
import '../constants.dart';


class MovieListTile extends StatefulWidget {

  final Movie movie;

  MovieListTile({this.movie});

  @override
  _MovieListTileState createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {

  Movie movie;


  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Row(
        children: <Widget>[
          movie.posterPath != null
              ? Hero(tag: movie.id, child: Image.network("$imageURL${movie.posterPath}"))
              : Container(width: 92.0,height: 138.0,color: Colors.blueGrey, child: Icon(Icons.movie),),


          Expanded(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("${movie.title}"),
                    subtitle: Text("${movie.overview}", maxLines: 3,),
                    trailing: IconButton(
                        icon: Icon(movie.favored ? Icons.star : Icons.star_border),
                        onPressed: (){}
                    ),
                  ),
                  Divider(),
                ],
              )
          )

        ],
      )
    );
  }
}
