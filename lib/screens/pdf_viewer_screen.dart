import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/class/render_pdf_to_image.dart';
import 'package:pdf_reader/screens/pdf_grid_viewer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _currentPage = 1;
  int? savedCurrentPage;
  bool _showOnyPdf = false;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    loadSharedPreferences();
    _isLoading = false;
    savedCurrentPage; //get from shared storage
    super.initState();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    int _totalPages = widget.document.count;
    List<Uint8List> pdfImages = [];
    print('savedIndex: $savedCurrentPage');

    return Scaffold(
      // backgroundColor: Colors.yellow,
      // appBar: AppBar(
      //   title: const Text('Pdf Viewer'),
      //   actions: [
      //     IconButton(
      //       onPressed: storeCurrentPageIndex,
      //       icon: Icon(savedCurrentPage == _currentPage
      //           ? Icons.bookmark
      //           : Icons.bookmark_border),
      //     ),
      //     IconButton(
      //       onPressed: () async {
      //         if (pdfImages.isEmpty) return;
      //         final int? selectedPage = await Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (context) => PdfGridViewerScreen(pdfImages),
      //           ),
      //         );
      //         if (selectedPage != null) {
      //           if (_pageController.hasClients) {
      //             _pageController.jumpToPage(selectedPage - 1);
      //           }
      //         }
      //       },
      //       icon: const Icon(Icons.grid_view_rounded),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Visibility(
            visible: !_showOnyPdf,
            child: AppBar(
              title: const Text('Pdf Viewer'),
              actions: [
                IconButton(
                  onPressed: storeCurrentPageIndex,
                  icon: Icon(savedCurrentPage == _currentPage
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                ),
                IconButton(
                  onPressed: () async {
                    if (pdfImages.isEmpty) return;
                    final int? selectedPage = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PdfGridViewerScreen(pdfImages),
                      ),
                    );
                    if (selectedPage != null) {
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(selectedPage - 1);
                      }
                    }
                  },
                  icon: const Icon(Icons.grid_view_rounded),
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GestureDetector(
                    onTap: toogleView,
                    child: Scrollbar(
                      controller: _pageController,
                      isAlwaysShown: true,
                      interactive: true,
                      thickness: 15,
                      radius: const Radius.circular(28),
                      child: PDFViewer(
                        lazyLoad: false,
                        showNavigation: false,
                        controller: _pageController,
                        document: widget.document,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPage = index + 1;
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              width: 100,
                              behavior: SnackBarBehavior.floating,
                              content: Text('Page ${index + 1}/$_totalPages'),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        showIndicator: false,
                        showPicker: false,
                        zoomSteps: 1,
                      ),
                    ),
                  ),
                ),
          Visibility(
            visible: !_showOnyPdf,
            child: FutureBuilder(
              future: RenderPdfToImage().getImages(widget.filePath),
              builder: (context, AsyncSnapshot<List?> snapshot) {
                // print(snapshot.data);
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (_isLoading || snapshot.hasData && snapshot.data != null) {
                  pdfImages = snapshot.data as List<Uint8List>;

                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => Image.memory(
                        snapshot.data![index],
                        height: 200,
                      ),
                      // children: snapshot.data.map((uint8List) => MemoryImage(uint8List)).toList(),
                    ),
                  );
                }
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void storeCurrentPageIndex() async {
    await _prefs.setInt('pdfIndex', _currentPage);
    setState(() {
      savedCurrentPage = _currentPage;
      print('savedIndex: $savedCurrentPage');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // width: 100,
        behavior: SnackBarBehavior.floating,
        content: Text('Page $_currentPage saved'),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  void loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCurrentPage = _prefs.getInt('pdfIndex');
    });
    print(
        'savedIndex: $savedCurrentPage  -------------------**************-----------');
    if (savedCurrentPage == null) return;
    _pageController.jumpToPage(savedCurrentPage! - 1);
  }

  void toogleView() {
    setState(() {
      _showOnyPdf = !_showOnyPdf;
    });
    print('_showOnyPdf: $_showOnyPdf');
  }
}
