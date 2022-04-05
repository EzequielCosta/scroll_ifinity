import 'package:flutter/material.dart';
import 'package:scroll_infinity/album.dart';
import 'package:scroll_infinity/album_widget.dart';

class ListViewWidget extends StatelessWidget{
  final List<Album> albums;
  final ScrollController scrollController;

  const ListViewWidget({required this.albums,required this.scrollController, Key? key,}): super(key: key);

    @override
  Widget build(BuildContext context) {
  
    //albums
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: albums.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () => showSnackBar(context, albums[index].title ),
            child: Container(
              height: 50,
              color: Colors.blueGrey,
              child: AlbumWidget( id: albums[index].id,title: albums[index].title,),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 4,
      ),

    );
    // ListView(padding: EdgeInsets.all(8), children: widgets);
  }

    void showSnackBar(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text("Album '$title' clicado!"),
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