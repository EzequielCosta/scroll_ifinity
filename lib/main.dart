import 'dart:convert';

import 'package:flutter/material.dart';

import 'album.dart';
import 'albuns.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late Future<Albuns> futureAlbum;
  int page = 1;
  int limitPerPage = 20;
  late final ScrollController _scrollController;

  late Albuns a = Albuns();

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("ola");
        setState(() {
          futureAlbum = fetchAlbum();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List of the Albums',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('List of the Albums'),
          ),
          body: FutureBuilder(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListViewAlbums(
                    snapshot.data as Albuns, _scrollController);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return CircularProgressIndicator();
            },
          )),
    );
  }

  void getAl() async {
    setState(() {
      a.add(fetchAlbum());
    });
  }

  Future<Albuns> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/albums?_page=$page&_limit=$limitPerPage'));

    if (response.statusCode == 200) {
      Albuns albuns = Albuns();
      List<dynamic> AlbunsJson = jsonDecode(response.body);

      setState(() {
        page++;
      });

      AlbunsJson.forEach((element) => {albuns.add(Album.fromJson(element))});
      return albuns;
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Album');
    }
  }
}

class AlbumWidget extends StatelessWidget {
  Album album;
  AlbumWidget(this.album, {Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Center(child: Text("${album.id} - ${album.title}")));
  }
}

class ListViewAlbums extends StatefulWidget {
  Albuns albums;
  ScrollController _scrollController;
  ListViewAlbums(this.albums, this._scrollController, {Key? key})
      : super(key: key);
  @override
  State<ListViewAlbums> createState() {
    return ListViewAlbumsState();
  }
}

class ListViewAlbumsState extends State<ListViewAlbums> {
  //ListViewAlbumsState(widget.albums, this.page);

  //final _scrollController = ScrollController();

  Widget build(BuildContext context) {
    List<AlbumWidget> widgets = [];

    widget.albums.albuns.forEach((e) {
      widgets.add(AlbumWidget(e));
    });
    //albums
    return ListView.separated(
      controller: widget._scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              showSnackBar(context, widgets[index]);
            },
            child: Container(
              height: 50,
              color: Colors.blueGrey,
              child: widgets[index],
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 4,
      ),
    );
    // ListView(padding: EdgeInsets.all(8), children: widgets);
  }

  void showSnackBar(BuildContext context, AlbumWidget album) {
    final snackBar = SnackBar(
      content: Text("Album '${album.album.title}' clicado!"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
