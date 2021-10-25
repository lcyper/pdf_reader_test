import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  const PdfViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isLoading = true;
  late PdfController pdfController;

  @override
  void initState() {
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.filePath),
    );
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // int _totalPages = widget.document.count;
    PageController _pageController = PageController();
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Pdf Viewer'),
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scrollbar(
                // controller: _pageController,
                isAlwaysShown: true,
                interactive: true,
                thickness: 15,
                radius: const Radius.circular(28),
                child: PdfView(
                  controller: pdfController,
                  scrollDirection: Axis.vertical,
                ),
                // PDFViewer(
                //   controller: _pageController,
                //   document: widget.document,
                //   scrollDirection: Axis.vertical,
                //   onPageChanged: (index) {
                //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         width: 100,
                //         behavior: SnackBarBehavior.floating,
                //         content: Text('Page ${index + 1}/$_totalPages'),
                //         duration: const Duration(milliseconds: 500),
                //       ),
                //     );
                //   },
                //   showIndicator: false,
                //   showPicker: false,
                //   zoomSteps: 1,
                // ),
              ),
      ),
    );
  }
}
