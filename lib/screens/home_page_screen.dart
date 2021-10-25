import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reader/screens/pdf_viewer_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.title}) : super(key: key);
  final String title;

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
                String filePath = await createFileOfPdfUrl(
                    'https://juventudedesporto.cplp.org/files/sample-pdf_9359.pdf');

                ScaffoldMessenger.of(context).clearSnackBars();
                _openPdfViewerScreen(context, filePath);
              },
              icon: const Icon(Icons.cloud),
              label: const Text('From Internet'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? _result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf']);
                if (_result == null) return;
                // File _file = File(_result.files.single.path!);
                // PDFDocument _document = await PDFDocument.fromFile(_file);
                _openPdfViewerScreen(context, _result.files.single.path!);
              },
              icon: const Icon(Icons.folder_rounded),
              label: const Text('From Storage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _openPdfViewerScreen(BuildContext context, String filePath) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(filePath: filePath),
      ),
    );
  }

  Future<String> createFileOfPdfUrl(String url) async {
    final _url = url;
    final filename = _url.substring(_url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(_url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    // return file;
    return '$dir/$filename';
  }
}
