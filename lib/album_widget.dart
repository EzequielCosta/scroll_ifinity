import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  final int id;
  final String title;

  const AlbumWidget({required this.id, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: Center(child: Text("${id} - ${title}")));
  }
}
