import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../services/pdf_generator.dart';
import '../widgets/flutter_spinner.dart';

/// Displays the generated PDF.
class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key, required this.pdfGenerator});

  /// The PDF generator to use.
  final PDFGenerator pdfGenerator;

  @override
  State<StatefulWidget> createState() => PDFViewerState();
}

class PDFViewerState extends State<PDFViewer> {
  /// The PDF generator.
  late PDFGenerator pdfGenerator;

  @override
  void initState() {
    super.initState();
    pdfGenerator = widget.pdfGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: pdfGenerator.generateResumeAsPDF(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.grey[350],
            child: const Center(
              child: FlutterSpinner(),
            ),
          );
        }
        return Theme(
          data: Theme.of(context).copyWith(brightness: Brightness.light),
          child: SfPdfViewer.memory(
            snapshot.data as Uint8List,
            pageLayoutMode: PdfPageLayoutMode.single,
          ),
        );
      },
    );
  }
}
