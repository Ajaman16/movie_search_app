import 'package:flutter/material.dart';
import 'package:movie_search_app/src/models/movie_model.dart';
import 'package:rxdart/rxdart.dart';
import '../database/movie_db.dart';
import '../constants.dart';

class Favored extends StatefulWidget {
  @override
  _FavoredState createState() => _FavoredState();
}

class _FavoredState extends State<Favored> {

  List<Movie> filteredMovies = List();
  List<Movie> cachedMovies = List();

  final PublishSubject subject = PublishSubject<String>();


  @override
  void initState() {
    super.initState();
    filteredMovies = [];
    cachedMovies = [];
    subject.stream.listen(searchDataList);

    setupList();
  }

  void setupList()async{
    MovieDb db = MovieDb();
    filteredMovies = await db.fetchMovies();
    setState(() {
      cachedMovies = filteredMovies;
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void searchDataList(query){

    if(query.isEmpty){
      setState(() {
        filteredMovies = cachedMovies;
      });
    }

    print("hello");

    setState(() {});
    filteredMovies = filteredMovies
        .where((movie){
        return movie.title.toLowerCase().trim().contains(RegExp(r'' + query.toLowerCase().trim() + ''));
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[

          TextField(
            onChanged: (value){
              subject.add(value);
            },
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: "search movies",
              border: OutlineInputBorder()
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 10.0),),

          Expanded(
              child:ListView.builder(
                //padding: EdgeInsets.all(10.0),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index){
                    return buildListItem(context, index);
                  }
              )
          )
        ],
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {

    return Card(
      child: ExpansionTile(
          initiallyExpanded: filteredMovies[index].isExpanded ?? false,
          onExpansionChanged: (b){
            filteredMovies[index].isExpanded = b;
          },

          leading: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onPressed(index)
          ),

          title: Row(
            children: <Widget>[
              filteredMovies[index].posterPath != null
                  ? Hero(tag: filteredMovies[index].id, child: Image.network("$imageURL${filteredMovies[index].posterPath}"))
                  : Container(width: 92.0,height: 138.0,color: Colors.blueGrey, child: Icon(Icons.movie),),

              Expanded(
                child: Text("${filteredMovies[index].title}"),
              )

            ],
          ),

          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: "${filteredMovies[index].overview}"
                )
            )
          ],
      ),
    );
  }

 void onPressed(int index) {

    MovieDb db = MovieDb();
    db.deleteMovie(filteredMovies[index].id);

    setState(() {
      filteredMovies.remove(filteredMovies[index]);
    });
 }
}
