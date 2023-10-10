import 'dart:convert';
import 'dart:html' as html;

import 'pdf_generator.dart';

/// A class that handles file operations.
class FileHandler {
  /// Saves the PDF to the user's device.
  Future<void> savePDF(PDFGenerator pdfGenerator) async {
    final String docID =
        '${DateTime.now().month}${DateTime.now().day}${DateTime.now().year.toString().substring(2)}-${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}';
    final String content =
        base64Encode(await pdfGenerator.generateResumeAsPDF());
    html.AnchorElement(
        href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
      ..setAttribute('download',
          '${pdfGenerator.resume.nameController.text} Resume $docID.pdf')
      ..click();
  }
}
