import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scroll_infinity/progress_indicator.dart';
import 'album.dart';
import 'package:http/http.dart' as http;
import 'list_view_albums.dart';

void main() {
  runApp(const _Home());
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<_Home> {
  int page = 1;
  int limitPerPage = 20;
  late final ScrollController _scrollController;
  late List<Album> listAlbuns;
  bool loading = false;
  bool allLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchAlbum();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !allLoaded) {
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
          children: <Widget>[
            ListViewWidget(
                albums: listAlbuns, scrollController: _scrollController),
            if (loading) ...[
              CircularProgressIndicatorListView(
                alignment:
                    (page == 1 ? Alignment.center : Alignment.bottomCenter),
              )
            ],
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
      List<dynamic> albunsJson = jsonDecode(response.body);

      await Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        for (Map<String, dynamic> element in albunsJson) {
          listAlbuns.add(Album.fromJson(element));
        }

        page++;
        allLoaded = albunsJson.isEmpty;
      });
    } else {
      throw Exception('Failed to load Album');
    }

    setState(() {
      loading = false;
    });
  }
}
