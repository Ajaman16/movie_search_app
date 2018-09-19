import 'package:flutter/material.dart';
import 'package:movie_search_app/src/database/movie_db.dart';
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

    MovieDb db = MovieDb();
    db.fetchMovie(movie.id).then((m){
      setState(() {
        if(m != null)
          movie.favored = m.favored;
      });
    });
  }

  void onPressed(){

    MovieDb db = MovieDb();

    setState(() {
      movie.favored = !movie.favored;
    });
    movie.favored ? db.addMovie(movie) : db.deleteMovie(movie.id);
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
            onPressed: onPressed
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
