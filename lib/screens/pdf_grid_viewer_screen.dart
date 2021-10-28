import 'dart:typed_data';

import 'package:flutter/material.dart';

class PdfGridViewerScreen extends StatelessWidget {
  final List<Uint8List> imagesList;

  PdfGridViewerScreen(this.imagesList, {Key? key}) : super(key: key);

  final ScrollController _pageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(),
      body: SafeArea(
        child: Scrollbar(
          controller: _pageController,
          isAlwaysShown: true,
          interactive: true,
          thickness: 15,
          radius: const Radius.circular(28),
          child: SingleChildScrollView(
            controller: _pageController,
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              direction: Axis.horizontal,
              children: createBoxes(context, imagesList),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createBoxes(BuildContext context, List<Uint8List> images) {
    List<Widget> widgetsList = [];

    final int _length = images.length;
    for (var i = 0; i < _length; i++) {
      widgetsList.add(MaterialButton(
        onPressed: () {
          Navigator.pop(context, (i + 1));
        },
        child: Column(
          children: [
            Text('${i + 1}'),
            Container(
              color: Colors.white,
              child: Image.memory(images[i]),
              width: 150,
              height: 150,
            ),
          ],
        ),
      ));
    }

    return widgetsList;
  }
}
