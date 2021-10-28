import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/pdf_viewer_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  final String _filePath = 'assets/bereshit.pdf';

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
                    await PDFDocument.fromAsset(widget._filePath);
                ScaffoldMessenger.of(context).clearSnackBars();
                _openPdfViewerScreen(
                    context: context,
                    document: _document,
                    filePath: widget._filePath);
              },
              icon: const Icon(Icons.cloud),
              label: const Text('From Assets'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? _result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf']);
                if (_result == null) return;
                File _file = File(_result.files.single.path!);
                PDFDocument _document = await PDFDocument.fromFile(_file);
                _openPdfViewerScreen(
                  context: context,
                  document: _document,
                  filePath: _result.files.single.path!,
                );
              },
              icon: const Icon(Icons.folder_rounded),
              label: const Text('Pick From Storage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _openPdfViewerScreen(
      {required BuildContext context,
      required PDFDocument document,
      required String filePath}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PdfViewerScreen(document: document, filePath: filePath),
      ),
    );
  }
}
