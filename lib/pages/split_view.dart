import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/contact.dart';
import 'package:flutter_resume_builder/models/education.dart';
import 'package:flutter_resume_builder/models/experience.dart';
import 'package:flutter_resume_builder/models/resume.dart';
import 'package:flutter_resume_builder/pages/input_form.dart';
import 'package:flutter_resume_builder/pages/pdf_viewer.dart';
import 'package:flutter_resume_builder/services/pdf_generator.dart';
import 'package:provider/provider.dart';

class SplitView extends StatefulWidget {
  const SplitView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SplitViewState();
}

class RecompileIntent extends Intent {
  const RecompileIntent();
}

class SplitViewState extends State<SplitView> {
  final Resume _resume = Resume();

  late PDFGenerator pdfGenerator;
  @override
  void initState() {
    super.initState();
    _populateSampleResume();
    pdfGenerator = PDFGenerator(resume: _resume);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _resume,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: const [
                Text(Strings.resumeBuilder),
                SizedBox(width: 15),
                Text(
                  Strings.poweredByFlutter,
                  style: TextStyle(fontSize: 15, color: Colors.white30),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    String docID =
                        "${DateTime.now().month}${DateTime.now().day}${DateTime.now().year.toString().substring(2)}-${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                    final content =
                        base64Encode(await pdfGenerator.generateResumeAsPDF());
                    html.AnchorElement(
                        href:
                            "data:application/octet-stream;charset=utf-16le;base64,$content")
                      ..setAttribute("download",
                          "${pdfGenerator.resume.name} Resume $docID.pdf")
                      ..click();
                  },
                  tooltip: Strings.download,
                  icon: const Icon(Icons.download)),
            ],
            centerTitle: false,
          ),
          body: Consumer<Resume>(builder: (context, value, child) {
            return Shortcuts(
              shortcuts: <ShortcutActivator, Intent>{
                LogicalKeySet(
                        LogicalKeyboardKey.meta, LogicalKeyboardKey.enter):
                    const RecompileIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  RecompileIntent: CallbackAction<RecompileIntent>(
                    onInvoke: (RecompileIntent intent) => setState(() {
                      _resume.formKey.currentState!.saveAndValidate();
                    }),
                  ),
                },
                child: Row(
                  children: [
                    Flexible(child: InputForm(resume: _resume)),
                    Flexible(child: _pdfViewer())
                  ],
                ),
              ),
            );
          })),
    );
  }

  _populateSampleResume() {
    _resume.name = "John Doe";
    _resume.location = 'California, USA';
    _resume.contactList = [
      Contact(details: 'johndoe@email.com', icon: CupertinoIcons.mail),
      Contact(details: 'linkedin.com/in/jdoe', icon: CupertinoIcons.link),
      Contact(details: '123-456-7890', icon: CupertinoIcons.phone),
      Contact(
          details: 'example.com/portfolio/jdoe', icon: CupertinoIcons.globe),
    ];
    _resume.experienceList = [
      Experience(
        company: 'Example Holdings Inc.',
        position: 'Software Engineer',
        startDate: DateTime.now().subtract(const Duration(days: 821)),
        endDate: DateTime.now(),
        imageURL:
            "https://static.vecteezy.com/system/resources/previews/006/921/781/original/real-estate-logo-construction-architecture-building-logo-design-template-element-free-vector.jpg",
        description:
            "• Installed and configured software applications and tested solutions for effectiveness.\n• Worked with project managers, developers, quality assurance and customers to resolve\n  technical issues.\n• Interfaced with cross-functional team of business analysts, developers and technical\n  support professionals to determine comprehensive list of requirement specifications for\n  new applications.",
      ),
      Experience(
        company: 'Example Technologies',
        position: 'Software Development Associate',
        startDate: DateTime.now().subtract(const Duration(days: 1200)),
        endDate: DateTime.now().subtract(const Duration(days: 821)),
        imageURL:
            "https://raw.githubusercontent.com/pyg-team/pyg_sphinx_theme/master/pyg_sphinx_theme/static/img/pyg_logo.png",
        description:
            "• Administered government-supported community development programs and promoted\n  department programs and services.\n• Worked closely with clients to establish problem specifications and system designs.\n• Developed next generation integration platform for internal applications.",
      ),
      Experience(
        position: 'Web Development Intern',
        company: 'Example Appraisal Services',
        startDate: DateTime.now().subtract(const Duration(days: 1350)),
        endDate: DateTime.now().subtract(const Duration(days: 1200)),
        imageURL:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjcEUlFwbhGT4aFNs7CWkY-1PuDejQ_Zl5aQA54A1K2Y3QXGr7cQhmQ2QGkqZM6M_tF4M&usqp=CAU",
        description:
            "• Participated with preparation of design documents for trackwork, including alignments,\n  specifications, criteria details and estimates.\n• Collaborated with senior engineers on projects and offered insight.\n• Engaged in software development utilizing wide range of technological tools and\n  industrial Ethernet-based protocols.",
      )
    ];
    _resume.educationList = [
      Education(
        institution: 'Example University',
        degree: 'MS, Software Engineering',
        startDate: DateTime.now().subtract(const Duration(days: 2080)),
        endDate: DateTime.now().subtract(const Duration(days: 1350)),
        imageURL:
            "https://media.istockphoto.com/id/1135962989/vector/university-campus-logo-with-text-space-for-your-slogan-tag-line-illustration.jpg?s=612x612&w=0&k=20&c=QRLY_rl52qazBfxNg1MvqSiQpyRhyizzIDR5waBvZKs=",
      ),
      Education(
        institution: 'Example State University',
        degree: 'BS, Computer Science',
        startDate: DateTime.now().subtract(const Duration(days: 3540)),
        endDate: DateTime.now().subtract(const Duration(days: 2080)),
      ),
    ];
  }

  Widget _pdfViewer() {
    return Stack(
      children: [
        PDFViewer(pdfGenerator: pdfGenerator),
        _resume.showRecompileButton
            ? Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: MaterialButton(
                    color: Colors.green[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _resume.formKey.currentState!.saveAndValidate();
                    },
                    minWidth: 25,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.sync,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          Strings.recompile,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
