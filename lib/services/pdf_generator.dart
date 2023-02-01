import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/education.dart';
import 'package:flutter_resume_builder/models/experience.dart';
import 'package:flutter_resume_builder/models/resume.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PDFGenerator {
  Resume resume;

  PDFGenerator({required this.resume});

  generateResumeAsPDF() async {
    final pdf = Document();

    pdf.addPage(
      Page(
        theme: ThemeData.withFont(
          base: await PdfGoogleFonts.robotoRegular(),
          bold: await PdfGoogleFonts.robotoBold(),
          icons: await PdfGoogleFonts.cupertinoIcons(),
        ),
        pageFormat: PdfPageFormat.letter,
        margin: const EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 25),
        build: (Context context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _name(),
              _location(),
              _contactGrid(),
              // SizedBox(height: 8),
              // _summary(),
              SizedBox(height: 8),
              _sectionLabel(Strings.experience),
              SizedBox(height: 8),
              _listOfExperiences(),
              Spacer(),
              _sectionLabel(Strings.education),
              SizedBox(height: 8),
              _listOfEducation(),
              Spacer(),
              _footer(),
            ],
          );
        },
      ),
    );
    return await pdf.save();
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _name() {
    return Text(
      resume.name,
      style: const TextStyle(fontSize: 28),
    );
  }

  Widget _location() {
    return Text(
      resume.location,
      style: const TextStyle(fontSize: 12),
    );
  }

  Widget _summary() {
    return resume.summary.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionLabel(Strings.summary),
              SizedBox(height: 8),
              Text(
                resume.summary,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          );
  }

  Widget _contactGrid() {
    return Column(
      children: [
        SizedBox(height: 10),
        Table(
          children: [
            for (int iterator = 0;
                iterator < resume.contactList.length;
                iterator = iterator + 2)
              TableRow(
                verticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  resume.contactList[iterator].details.isEmpty
                      ? Container()
                      : resume.contactList[iterator].showImage
                          ? Image(resume.contactList[iterator].imageProvider,
                              width: 22, height: 22)
                          : Icon(
                              IconData(resume
                                  .contactList[iterator].iconData.codePoint),
                              size: 22,
                              color: const PdfColor(0.65, 0.65, 0.65),
                            ),
                  Text(
                    resume.contactList[iterator].details,
                    style: const TextStyle(fontSize: 12),
                  ),
                  iterator < resume.contactList.length - 1 &&
                          resume.contactList[iterator + 1].details.isNotEmpty
                      ? resume.contactList[iterator + 1].showImage
                          ? Image(
                              resume.contactList[iterator + 1].imageProvider,
                              width: 22,
                              height: 22)
                          : Icon(
                              IconData(resume.contactList[iterator + 1].iconData
                                  .codePoint),
                              size: 22,
                              color: const PdfColor(0.65, 0.65, 0.65),
                            )
                      : Container(),
                  Text(
                    iterator < resume.contactList.length - 1
                        ? resume.contactList[iterator + 1].details
                        : "",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  Widget _listOfExperiences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (Experience experience in resume.experienceList)
          _experienceDetails(experience)
      ],
    );
  }

  Widget _experienceDetails(Experience experience) {
    return experience.position.isEmpty && experience.company.isEmpty
        ? Container()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              experience.showImage
                  ? Image(experience.imageProvider, width: 22, height: 22)
                  : Icon(
                      IconData(experience.iconData.codePoint),
                      size: 22,
                      color: const PdfColor(0.65, 0.65, 0.65),
                    ),
              SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      experience.position,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      experience.company,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      _positionStartAndEndDate(experience),
                      style: const TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        experience.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: PdfColor(0.15, 0.15, 0.15),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          );
  }

  String _positionStartAndEndDate(Experience experience) {
    String lengthText =
        "${DateFormat('MMM yyyy').format(experience.startDate)} - ";
    bool present = false;

    if (experience.endDate.difference(DateTime.now()).inDays >= 0) {
      lengthText += "Present (";
      present = true;
    } else {
      lengthText += "${DateFormat('MMM yyyy').format(experience.endDate)} (";
    }

    int years = ((experience.endDate.difference(experience.startDate).inDays /
            30.417) ~/
        12);
    if (years > 0) {
      lengthText += "$years year";
      if (years > 1) {
        lengthText += "s";
      }
      lengthText += " ";
    }

    int months =
        (experience.endDate.difference(experience.startDate).inDays ~/ 30.417) -
            (12 * years);
    if (months > 0) {
      lengthText += "$months month";
    }
    if (months > 1) {
      lengthText += "s";
    }
    if (present) {
      lengthText += "+";
    }
    lengthText += ")";

    return lengthText;
  }

  Widget _listOfEducation() {
    return Row(
      children: [
        for (Education education in resume.educationList)
          _educationDetails(education)
      ],
    );
  }

  Widget _educationDetails(Education education) {
    return Expanded(
      child: Row(
        children: [
          education.showImage
              ? Image(education.imageProvider, width: 24, height: 24)
              : Icon(
                  IconData(education.iconData.codePoint),
                  color: const PdfColor(0.7, 0.7, 0.7),
                ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                education.institution,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                education.degree,
                style: const TextStyle(fontSize: 14),
              ),
              education.endDate.difference(DateTime.now()).inDays >= 0
                  ? Text(
                      '${DateFormat('MMM yyyy').format(education.startDate)} - Present',
                      style: const TextStyle(fontSize: 12),
                    )
                  : Text(
                      '${DateFormat('MMM yyyy').format(education.startDate)} - ${DateFormat('MMM yyyy').format(education.endDate)}',
                      style: const TextStyle(fontSize: 12),
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget _skillsList() {
    return resume.skillList.isEmpty
        ? Container()
        : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _sectionLabel(Strings.skills),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (int iterator = 0;
                    iterator < resume.skillList.length;
                    iterator++)
                  Text(
                    '${resume.skillList[iterator]}${iterator + 1 < resume.skillList.length ? " • " : ""}',
                    style: const TextStyle(fontSize: 10),
                  )
              ],
            )
          ]);
  }

  Widget _footer() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            '${resume.name} - Page 1 / 1',
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
}
