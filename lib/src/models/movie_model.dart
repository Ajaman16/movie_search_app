import 'package:meta/meta.dart';

class Movie{
  String title, posterPath, id, overview;
  bool favored, isExpanded;

  Movie({@required this.title, @required this.id, @required this.overview, @required this.posterPath, this.favored, this.isExpanded});

  Movie.fromJSON(Map<String, dynamic> json):
      title = json["title"],
      posterPath = json["poster_path"],
      id = json["id"].toString(),
      overview = json["overview"],
      favored = false,
      isExpanded = false;

  Movie.fromDb(Map<String, dynamic> json):
      title = json["title"],
      posterPath = json["posterPath"],
      id = json["id"],
      overview = json["overview"],
      favored = json["favored"] == 1,
      isExpanded = false;

  Map<String, dynamic> toMapforDb(){
    return <String, dynamic>{
      "title": title,
      "posterPath": posterPath ?? "",
      "id": id,
      "overview": overview ?? "",
      "favored": favored ? 1 : 0
    };
  }

}