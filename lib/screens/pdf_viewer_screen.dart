import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/class/render_pdf_to_image.dart';
// import 'package:pdf_reader/class/render_pdf_to_image.dart';

class PdfViewerScreen extends StatefulWidget {
  final PDFDocument document;
  final String filePath;
  const PdfViewerScreen(
      {Key? key, required this.document, required this.filePath})
      : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _totalPages = widget.document.count;
    PageController _pageController = PageController();
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Pdf Viewer'),
      ),
      body: Column(
        children: [
          // _isLoading
          //     ? const Center(child: CircularProgressIndicator())
          //     : Scrollbar(
          //         controller: _pageController,
          //         isAlwaysShown: true,
          //         interactive: true,
          //         thickness: 15,
          //         radius: const Radius.circular(28),
          //         child: PDFViewer(
          //           controller: _pageController,
          //           document: widget.document,
          //           scrollDirection: Axis.vertical,
          //           onPageChanged: (index) {
          //             ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(
          //                 width: 100,
          //                 behavior: SnackBarBehavior.floating,
          //                 content: Text('Page ${index + 1}/$_totalPages'),
          //                 duration: const Duration(milliseconds: 500),
          //               ),
          //             );
          //           },
          //           showIndicator: false,
          //           showPicker: false,
          //           zoomSteps: 1,
          //         ),
          //       ),
          FutureBuilder(
            future: RenderPdfToImage().getImages(widget.filePath),
            builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
              print(snapshot.data);
              return _isLoading || snapshot.hasData && snapshot.data != null
                  ? Row(
                      children: [Image.memory(snapshot.data!)],
                      // children: snapshot.data.map((uint8List) => MemoryImage(uint8List)).toList(),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
