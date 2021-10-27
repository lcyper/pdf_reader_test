import 'dart:typed_data';

import 'package:native_pdf_renderer/native_pdf_renderer.dart';

// import 'package:pdf_image_renderer/pdf_image_renderer.dart';

// class RenderPdfToImage {
//   // final String filePath;

//   // RenderPdfToImage(this.filePath);

//   Future<Uint8List?> getImages(String filePath,
//       [int pageIndex = 0]) async {
//     Uint8List image; //imagen list?

//     late final PdfImageRendererPdf _pdf;
//     // Initialize the renderer
//     _pdf = PdfImageRendererPdf(path: filePath);

//     // void renderPdfImage() async {
//     // Get a path from a pdf file (we are using the file_picker package (https://pub.dev/packages/file_picker))
//     // String path = await FilePicker.getFilePath(type: FileType.custom, allowedExtensions: ['pdf']);

//     // open the pdf document
//     await _pdf.open();

//     // open a page from the pdf document using the page index
//     await _pdf.openPage(pageIndex: 0);

//     // get the render size after the page is loaded
//     final size = await _pdf.getPageSize(pageIndex: 0);

//     // get the actual image of the page
//     final Uint8List? img = await _pdf.renderPage(
//       pageIndex: pageIndex,
//       x: 0,
//       y: 0,
//       width: size.width, // you can pass a custom size here to crop the image
//       height: size.height, // you can pass a custom size here to crop the image
//       scale: 1, // increase the scale for better quality (e.g. for zooming)
//       // background: Colors.white,
//     );

//     // close the page again
//     await _pdf.closePage(pageIndex: 0);

//     // close the PDF after rendering the page
//     _pdf.close();

//     // image = img;
//     return img;
//   }
// }

class RenderPdfToImage {
  Future<Uint8List?> getImages(String filePath) async {
    final PdfDocument document = await PdfDocument.openAsset(filePath);
    final PdfPage page = await document.getPage(1);
    final PdfPageImage? pageImage =
        await page.render(width: page.width, height: page.height);
    await page.close();

    return pageImage?.bytes;
  }
}
