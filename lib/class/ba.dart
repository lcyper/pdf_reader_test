import 'dart:typed_data';

import 'package:pdf_image_renderer/pdf_image_renderer.dart';

class RenderPdfToImage {
  final String filePath;
  Uint8List image; //imagen list?
  late final PdfImageRendererPdf _pdf;

  RenderPdfToImage(this.filePath){
    // Initialize the renderer
    final pdf = PdfImageRendererPdf(path: filePath);

  };

  // void renderPdfImage() async {
    // Get a path from a pdf file (we are using the file_picker package (https://pub.dev/packages/file_picker))
    // String path = await FilePicker.getFilePath(type: FileType.custom, allowedExtensions: ['pdf']);


    // open the pdf document
    await pdf.open()

    // open a page from the pdf document using the page index
    await pdf.openPage(pageIndex: 0);

    // get the render size after the page is loaded
    final size = await _pdf.getPageSize(pageIndex: 0);

    // get the actual image of the page
    final img = await _pdf.renderPage(
          pageIndex: pageIndex,
          x: 0,
          y: 0,
          width: size.width, // you can pass a custom size here to crop the image
          height: size.height, // you can pass a custom size here to crop the image
          scale: 1, // increase the scale for better quality (e.g. for zooming)
          background: Colors.white,
        );

    // close the page again
    await pdf.closePage(pageIndex: 0);

    // close the PDF after rendering the page
    pdf.close();

    // use setState to update the renderer
    // setState(() {
      image = img;
    // });
  // }
}