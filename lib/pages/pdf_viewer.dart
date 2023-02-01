import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/services/pdf_generator.dart';
import 'package:flutter_resume_builder/widgets/flutter_spinner.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({Key? key, required this.pdfGenerator}) : super(key: key);
  final PDFGenerator pdfGenerator;

  @override
  State<StatefulWidget> createState() => PDFViewerState();
}

class PDFViewerState extends State<PDFViewer> {
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
      initialData: null,
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
            snapshot.data,
            pageLayoutMode: PdfPageLayoutMode.single,
          ),
        );
      },
    );
  }
}
