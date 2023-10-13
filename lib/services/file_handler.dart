import 'dart:convert';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'pdf_generator.dart';
import 'project_info.dart';

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
          '${pdfGenerator.resume.nameController.text.replaceAll(' ', '_').toLowerCase()}_resume_$docID.pdf')
      ..click();
  }

  /// Saves the resume as a JSON file.
  void saveJSONData(
      {required PDFGenerator pdfGenerator,
      required ProjectVersionInfoHandler projectVersionInfoHandler}) {
    final String docID =
        '${DateTime.now().month}${DateTime.now().day}${DateTime.now().year.toString().substring(2)}-${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}';

    final String content = base64Encode(utf8.encode(
      jsonEncode(<String, dynamic>{
        'resume': pdfGenerator.resume.toMap(),
        'projectVersionInfo': projectVersionInfoHandler.toMap(),
      }),
    ));

    html.AnchorElement(
        href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
      ..setAttribute('download',
          '${pdfGenerator.resume.nameController.text.replaceAll(' ', '_').toLowerCase()}_resume_data_$docID.plgrb.json')
      ..click();
  }

  /// Import the resume JSON file.
  Future<dynamic> importResume() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['json'],
      );

      if (result != null) {
        final String content = utf8.decode(result.files.first.bytes!);
        return jsonDecode(content);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
