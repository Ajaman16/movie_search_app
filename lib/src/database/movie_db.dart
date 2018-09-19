import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/movie_model.dart';
import 'dart:io';
import 'dart:async';

class MovieDb{

  static final MovieDb _instance = MovieDb._internal();

  factory MovieDb() => _instance;

  static Database _db;

  Future<Database> get db async{

    if(_db != null)
      return _db;

    _db = await initDb();

    return _db;

  }

  MovieDb._internal();

  Future<Database> initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");

    var db = openDatabase(
        path,
        version: 1,
        onCreate: (Database mydb, int version){
          mydb.execute("""
            CREATE TABLE MOVIES
            (
              id TEXT PRIMARY KEY,
              title TEXT,
              posterPath TEXT,
              overview TEXT,
              favored INTEGER
            );
          """);
        }
    );

    return db;
  }

  Future<int> addMovie(Movie movie)async{

    try{
      var dbCLient = await db;
      int res = await dbCLient.insert(
        "MOVIES",
        movie.toMapforDb(),
        //conflictAlgorithm: ConflictAlgorithm.ignore
      );
      return res;
    }
    catch(e){
      print(e.toString());
      return updateMovie(movie);
    }


  }

  Future<int> updateMovie(Movie movie)async{

    var dbCLient = await db;

    return dbCLient.update(
        "MOVIES",
        movie.toMapforDb(),
        where: 'id=?',
        whereArgs: [movie.id]
    );

  }

  Future<int> deleteMovie(String id)async{

    var dbCLient = await db;

    return dbCLient.delete(
        "MOVIES",
        where: 'id=?',
        whereArgs: [id]
    );

  }

  Future<List<Movie>> fetchMovies()async{
    var dbClient = await db;
    List<Map> res = await dbClient.query("MOVIES");
    return res.map((m) => Movie.fromDb(m)).toList();
  }

  Future<Movie> fetchMovie(String id)async{
    var dbClient = await db;
    var res = await dbClient.query(
      "MOVIES",
      where: "id=?",
      whereArgs: [id]
    );

    if(res.length == 0)
      return null;

    return Movie.fromDb(res[0]);

  }

  Future<dynamic> closeDb()async{
    var dbCLient = await db;
    return dbCLient.close();
  }

}
