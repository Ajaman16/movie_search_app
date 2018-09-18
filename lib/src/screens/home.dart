import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_search_app/src/widget/movie_list_tile.dart';
import 'package:rxdart/rxdart.dart';
import '../models/movie_model.dart';
import '../constants.dart';
import '../database/movie_db.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Movie> list = List();
  bool hasLoaded = true;
  MovieDb db;

  final PublishSubject subject = PublishSubject<String>();


  @override
  void initState() {
    super.initState();
    db = MovieDb();
    db.initDb();
    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchMovies);
  }

  void searchMovies(query){
    resetMovies();
    if(query.isEmpty)
      {
        setState(() {
          hasLoaded = true;
        });
      }
    
    setState(() {
      hasLoaded = false;
    });

    http.get("$url$query")
    .then((res) => res.body)
    .then(json.decode)
    .then((map) => map["results"])
    .then((moviesList) => moviesList.forEach(addMovie))
    .catchError(onError)
    .then((e){
      setState(() {
        hasLoaded = true;
      });
    });

  }

  void onError(d) {
    print(d.toString());
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovie(item){
    setState(() {
      list.add(Movie.fromJSON(item));
    });

    //print("${list.map((movie) => movie.title)}");
  }

  void resetMovies() {
    setState(() {
      list.clear();
    });
  }

  @override
  void dispose() {
    db.closeDb();
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie App"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[

            TextField(
              onChanged: (value) => subject.add(value),
              decoration: InputDecoration(
                hintText: "Enter Movie name",
                border: OutlineInputBorder()
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 10.0),),
            hasLoaded ? Container() : CircularProgressIndicator(),

            Expanded(
                child:ListView.builder(
                  //padding: EdgeInsets.all(10.0),
                  itemCount: list.length,
                  itemBuilder: (context, index){
                    return MovieListTile(movie: list[index], db: db,);
                  }
                )
            )

          ],
        ),
      ),
    );
  }




}
