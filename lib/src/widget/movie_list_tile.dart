import 'package:flutter/material.dart';
import 'package:movie_search_app/src/database/movie_db.dart';
import 'package:movie_search_app/src/models/movie_model.dart';
import '../constants.dart';


class MovieListTile extends StatefulWidget {

  final Movie movie;
  final MovieDb db;

  MovieListTile({this.movie, this.db});

  @override
  _MovieListTileState createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {

  Movie movie;
  MovieDb db;

  @override
  void initState() {
    super.initState();
    db = widget.db;
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ExpansionTile(
        initiallyExpanded: movie.isExpanded,
        onExpansionChanged: (b) => movie.isExpanded = b,

        leading: IconButton(
            icon: Icon(movie.favored ? Icons.star : Icons.star_border),
            color: Colors.white,
            onPressed: (){
              setState(() {
                movie.favored = !movie.favored;
              });
              movie.favored ? db.addMovie(movie) : db.deleteMovie(movie.id);
            }
        ),
        title: Row(
          children: <Widget>[
            movie.posterPath != null
                ? Hero(tag: movie.id, child: Image.network("$imageURL${movie.posterPath}"))
                : Container(width: 92.0,height: 138.0,color: Colors.blueGrey, child: Icon(Icons.movie),),

            Expanded(
                child: Text("${movie.title}"),
            )

          ],
        ),
        children: <Widget>[
          RichText(
              text: TextSpan(
                text: "${movie.overview}"
              )
          )
        ],
      )
    );
  }
}
