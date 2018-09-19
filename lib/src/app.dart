import 'package:flutter/material.dart';
import 'package:movie_search_app/src/screens/home.dart';
import '../src/screens/favored.dart';

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Search Movies"),
              bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.home), text: "Home",),
                    Tab(icon: Icon(Icons.favorite), text: "Favored",)
                  ]
              ),
            ),

            body: TabBarView(
              children: <Widget>[
                Home(),
                Favored()
              ]
            ),
          )
      ),
    );
  }
}
