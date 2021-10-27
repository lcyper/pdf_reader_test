import 'package:pdf_image_renderer/pdf_image_renderer.dart';

// class PdfFileHandler {
//   static Future<List<PdfRawImage>> loadPdf(String path) async {
//     var file = PdfImageRendererPdf.PdfImageRendererPdf(path: path);
//     await file.open();
//     var count = await file.getPageCount();
//     var images = List<PdfRawImage>();
//     for (var i = 0; i < count; i++) {
//       var size = await file.getPageSize(pageIndex: i);
//       var rawImage = await file.renderPage(
//         background: Colors.transparent,
//         x: 0,
//         y: 0,
//         width: size.width,
//         height: size.height,
//         scale: 1.0,
//         pageIndex: i,
//       );
//       images.add(PdfRawImage(
//         data: rawImage,
//         size: Size(size.width.toDouble(), size.height.toDouble()),
//       ));
//     }
//     return images;
//   }
// }
