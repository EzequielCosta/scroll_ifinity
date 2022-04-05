import 'dart:convert';
import 'package:flutter/material.dart';
import 'album.dart';
import 'package:http/http.dart' as http;
import 'list_view_albums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int page = 1;
  int limitPerPage = 20;
  late final ScrollController _scrollController;
  late List<Album> listAlbuns;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchAlbum();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchAlbum();
      }
    });
    listAlbuns = [];
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
        body: Stack(
          children: [
            ListViewWidget(
                albums: listAlbuns, scrollController: _scrollController),
            loading ? CircularProgressIndicator() : SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> fetchAlbum() async {
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/albums?_page=$page&_limit=$limitPerPage'));

    if (response.statusCode == 200) {
      List<dynamic> AlbunsJson = jsonDecode(response.body);

      setState(() {
        AlbunsJson.forEach(
            (element) => {listAlbuns.add(Album.fromJson(element))});
        page++;
      });
    } else {
      throw Exception('Failed to load Album');
    }
    setState(() {
      loading = false;
    });
  }
}
