import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart' show PDFDocument;
import 'package:pdf_reader/screens/pdf_viewer_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  final String _urlFile =
      'https://drive.google.com/file/d/0B6MvcSFEGyoxdTVjMWlOSXVHbDQ/view?resourcekey=0-YQoksS6JJRGKog94HTNGww';

  @override
  State<HomePageScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Loading...')),
                );
                PDFDocument _document =
                    await PDFDocument.fromURL(widget._urlFile);
                ScaffoldMessenger.of(context).clearSnackBars();
                _openPdfViewerScreen(context, _document);
              },
              icon: const Icon(Icons.cloud),
              label: const Text('From Internet'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? _result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf']);
                if (_result == null) return;
                File _file = File(_result.files.single.path!);
                PDFDocument _document = await PDFDocument.fromFile(_file);
                _openPdfViewerScreen(context, _document);
              },
              icon: const Icon(Icons.folder_rounded),
              label: const Text('From Storage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _openPdfViewerScreen(
      BuildContext context, PDFDocument _document) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(document: _document),
      ),
    );
  }
}
