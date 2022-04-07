import 'package:flutter/material.dart';

class CircularProgressIndicatorListView extends StatelessWidget {
  final Alignment alignment;
  const CircularProgressIndicatorListView({required this.alignment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      alignment: alignment,
      //width: constraingts.maxWidth,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
          backgroundColor: Colors.black38,
        ),
      ),
    );
  }
}
