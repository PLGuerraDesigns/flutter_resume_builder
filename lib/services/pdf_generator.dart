import 'dart:typed_data';

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../common/strings.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/generic.dart';
import '../models/resume.dart';

/// Generates a PDF from a [Resume].
class PDFGenerator {
  PDFGenerator({required this.resume});

  /// The resume to be generated as PDF.
  Resume resume;

  /// A label for a section.
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Divider(
              indent: 8,
              thickness: 0.5,
              color: const PdfColor(0.45, 0.45, 0.45),
            ),
          ),
        ],
      ),
    );
  }

  /// The resume header.
  ///
  /// Includes the name, location, image, and contact details.
  Widget _header() {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _name(),
            _location(),
            SizedBox(height: 8),
            _contactGrid(),
          ],
        ),
        if (resume.logoAsBytes != null)
          Align(
            alignment: Alignment.centerRight,
            child: Image(
              MemoryImage(
                resume.logoAsBytes!,
              ),
              width: 75,
              height: 75,
            ),
          ),
      ],
    );
  }

  /// The contact details of the user.
  Widget _contactGrid() {
    return Table(
      children: <TableRow>[
        for (int iterator = 0;
            iterator < resume.contactList.length;
            iterator = iterator + 2)
          TableRow(
            children: <Widget>[
              if (resume.contactList[iterator].textController.text.isNotEmpty)
                Icon(
                  IconData(resume.contactList[iterator].iconData.codePoint),
                  size: 16,
                  color: const PdfColor(0.65, 0.65, 0.65),
                )
              else
                Container(width: 1),
              Text(
                resume.contactList[iterator].textController.text,
                style: const TextStyle(fontSize: 12),
              ),
              if (iterator < resume.contactList.length - 1 &&
                  resume
                      .contactList[iterator + 1].textController.text.isNotEmpty)
                Icon(
                  IconData(resume.contactList[iterator + 1].iconData.codePoint),
                  size: 16,
                  color: const PdfColor(0.65, 0.65, 0.65),
                )
              else
                Container(),
              Text(
                iterator < resume.contactList.length - 1
                    ? resume.contactList[iterator + 1].textController.text
                    : '',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
      ],
    );
  }

  /// The name of the user.
  Widget _name() {
    return Text(
      resume.nameController.text,
      style: const TextStyle(fontSize: 18),
    );
  }

  /// The location of the user.
  Widget _location() {
    return Row(
      children: <Widget>[
        Icon(
          IconData(cupertino.CupertinoIcons.map_pin_ellipse.codePoint),
          size: 14,
          color: const PdfColor(0.65, 0.65, 0.65),
        ),
        SizedBox(width: 4),
        Text(
          resume.locationController.text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// A date range in the format of `startDate - endDate`.
  String _dateRange(String startDate, String endDate) {
    if (startDate.isEmpty && endDate.isEmpty) {
      return '';
    } else if (startDate.isEmpty) {
      return endDate;
    } else if (endDate.isEmpty) {
      return startDate;
    } else {
      return '$startDate - $endDate';
    }
  }

  /// A custom section.
  Widget _customSection(int index, {required String sectionName}) {
    return resume.customSections.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _sectionLabel(sectionName),
              for (final Map<String, GenericEntry> genericSection
                  in resume.visibleCustomSections)
                if (genericSection.keys.first == sectionName)
                  _genericEntryDetails(genericSection.values.first)
            ],
          );
  }

  /// A generic entry.
  Widget _genericEntryDetails(GenericEntry genericSection) {
    return genericSection.titleController.text.isEmpty &&
            genericSection.descriptionController.text.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (!(genericSection.titleController.text.isEmpty &&
                  genericSection.startDateController.text.isEmpty &&
                  genericSection.endDateController.text.isEmpty))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      genericSection.titleController.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _dateRange(
                        genericSection.startDateController.text,
                        genericSection.endDateController.text,
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              if (!(genericSection.subtitleController.text.isEmpty &&
                  genericSection.locationController.text.isEmpty))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      genericSection.subtitleController.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      genericSection.locationController.text,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  genericSection.descriptionController.text,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PdfColor(0.15, 0.15, 0.15),
                  ),
                ),
              ),
            ],
          );
  }

  /// The professional experience section.
  Widget _experienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _sectionLabel(Strings.experience),
        for (final Experience experience in resume.visibleExperiences)
          _experienceEntryDetails(experience)
      ],
    );
  }

  /// An experience entry.
  Widget _experienceEntryDetails(Experience experience) {
    return experience.companyController.text.isEmpty &&
            experience.positionController.text.isEmpty &&
            experience.descriptionController.text.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    experience.positionController.text,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _dateRange(
                      experience.startDateController.text,
                      experience.endDateController.text,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (experience.companyController.text.isNotEmpty &&
                  experience.locationController.text.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      experience.companyController.text,
                    ),
                    Text(
                      experience.locationController.text,
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  experience.descriptionController.text,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PdfColor(0.15, 0.15, 0.15),
                  ),
                ),
              ),
              SizedBox(height: 4),
            ],
          );
  }

  /// The education section.
  Widget _educationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _sectionLabel(Strings.education),
        for (final Education education in resume.visibleEducation)
          _educationEntryDetails(education)
      ],
    );
  }

  /// An education entry.
  Widget _educationEntryDetails(Education education) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                education.degreeController.text,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                _dateRange(
                  education.startDateController.text,
                  education.endDateController.text,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(education.institutionController.text),
              Text(education.locationController.text),
            ],
          ),
        ],
      ),
    );
  }

  /// The skills section.
  Widget _skillsList() {
    return resume.skillTextControllers.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                _sectionLabel(Strings.skills),
                Wrap(
                  children: <Widget>[
                    for (int iterator = 0;
                        iterator < resume.skillTextControllers.length;
                        iterator++)
                      Text(
                        '${resume.skillTextControllers[iterator].text}${iterator + 1 < resume.skillTextControllers.length && resume.skillTextControllers[iterator + 1].text.isNotEmpty ? " • " : ""}',
                      )
                  ],
                )
              ]);
  }

  /// The resume footer.
  Widget _footer({required int currentPage, required int totalPages}) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            '${resume.nameController.text} - Page $currentPage / $totalPages',
            style:
                const TextStyle(color: PdfColor(0.5, 0.5, 0.5), fontSize: 10),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            DateFormat('MM/yyyy').format(DateTime.now()),
            style: const TextStyle(
                color: PdfColor(0.75, 0.75, 0.75), fontSize: 10),
          ),
        ),
      ],
    );
  }

  /// The sections of the resume in the order they should be displayed.
  List<Widget> _getOrderedSections() {
    final List<Widget> sections = <Widget>[];
    int sectionIndex = 0;
    for (final String sectionName in resume.sectionOrder) {
      if (!resume.sectionVisible(sectionName)) {
        continue;
      }
      switch (sectionName) {
        case Strings.skills:
          sections.add(_skillsList());
        case Strings.experience:
          sections.add(_experienceSection());
        case Strings.education:
          sections.add(_educationSection());
        default:
          sections.add(_customSection(sectionIndex, sectionName: sectionName));
      }
      sectionIndex++;
    }
    return sections;
  }

  /// Generates the resume as a PDF.
  Future<Uint8List> generateResumeAsPDF() async {
    final Document pdf = Document();

    pdf.addPage(
      MultiPage(
        theme: ThemeData.withFont(
          base: await PdfGoogleFonts.robotoRegular(),
          bold: await PdfGoogleFonts.robotoBold(),
          icons: await PdfGoogleFonts.cupertinoIcons(),
        ),
        pageFormat: PdfPageFormat.letter,
        margin: const EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 25),
        header: (Context context) {
          if (context.pageNumber == 1) {
            return _header();
          }
          return Container();
        },
        build: (Context context) => _getOrderedSections(),
        footer: (Context context) => Align(
          alignment: Alignment.bottomCenter,
          child: _footer(
            currentPage: context.pageNumber,
            totalPages: context.pagesCount,
          ),
        ),
      ),
    );
    return pdf.save();
  }
}
