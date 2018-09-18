import 'package:meta/meta.dart';

class Movie{
  final String title, posterPath, id, overview;
  final bool favored;

  Movie({@required this.title, @required this.id, @required this.overview, @required this.posterPath, this.favored});

  Movie.fromJSON(Map<String, dynamic> json):
      title = json["title"],
      posterPath = json["poster_path"],
      id = json["id"].toString(),
      overview = json["overview"],
      favored = false;

}