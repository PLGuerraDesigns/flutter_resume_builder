import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/strings.dart';
import '../models/contact.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/generic.dart';
import '../models/resume.dart';
import '../services/file_handler.dart';
import '../services/pdf_generator.dart';
import '../services/project_info.dart';
import '../services/redirect_handler.dart';
import '../widgets/portrait_drawer.dart';
import 'input_form.dart';
import 'pdf_viewer.dart';

/// Split view of the resume builder (input form and PDF viewer).
class SplitView extends StatefulWidget {
  const SplitView({super.key});
  @override
  State<StatefulWidget> createState() => SplitViewState();
}

class SplitViewState extends State<SplitView> with TickerProviderStateMixin {
  /// The resume to use.
  final Resume _resume = Resume();

  /// The project info handler.
  ProjectVersionInfoHandler projectInfoHandler = ProjectVersionInfoHandler();

  /// The PDF generator.
  late PDFGenerator pdfGenerator;

  /// The tab controller.
  TabController? _tabController;

  /// Populates the resume with sample data.
  void _populateSampleResume() {
    _resume.nameController.text = 'John Doe';
    _resume.locationController.text = 'San Francisco, CA';
    _resume.skillTextControllers = <TextEditingController>[
      TextEditingController(text: 'Flutter'),
      TextEditingController(text: 'Dart'),
      TextEditingController(text: 'Python'),
      TextEditingController(text: 'Java'),
      TextEditingController(text: 'C++'),
    ];
    _resume.contactList = <Contact>[
      Contact(value: 'johndoe@email.com', iconData: CupertinoIcons.mail),
      Contact(value: 'linkedin.com/in/jdoe', iconData: CupertinoIcons.link),
      Contact(value: '123-456-7890'),
      Contact(
          value: 'example.com/portfolio/jdoe', iconData: CupertinoIcons.globe),
    ];
    _resume.experiences = <Experience>[
      Experience(
        company: 'Example Holdings Inc.',
        position: 'Software Engineer',
        startDate: '01/2020',
        endDate: 'Present',
        location: 'San Francisco, CA',
        description:
            '• Installed and configured software applications and tested solutions for effectiveness.\n• Worked with project managers, developers, quality assurance and customers to resolve\n  technical issues.\n• Interfaced with cross-functional team of business analysts, developers and technical\n  support professionals to determine comprehensive list of requirement specifications for\n  new applications.',
      ),
      Experience(
        company: 'Example Technologies',
        position: 'Software Development Associate',
        startDate: '01/2019',
        endDate: '12/2019',
        location: 'San Francisco, CA',
        description:
            '• Administered government-supported community development programs and promoted\n  department programs and services.\n• Worked closely with clients to establish problem specifications and system designs.\n• Developed next generation integration platform for internal applications.',
      ),
      Experience(
        position: 'Web Development Intern',
        company: 'Example Appraisal Services',
        startDate: '06/2018',
        endDate: '08/2018',
        location: 'San Francisco, CA',
        description:
            '• Participated with preparation of design documents for trackwork, including alignments,\n  specifications, criteria details and estimates.\n• Collaborated with senior engineers on projects and offered insight.\n• Engaged in software development utilizing wide range of technological tools and\n  industrial Ethernet-based protocols.',
      )
    ];
    _resume.educationHistory = <Education>[
      Education(
        institution: 'Example University',
        degree: 'MS, Software Engineering',
        startDate: '08/2018',
        endDate: '12/2019',
        location: 'San Francisco, CA',
      ),
      Education(
        institution: 'Example State University',
        degree: 'BS, Computer Science',
        startDate: '08/2014',
        endDate: '05/2018',
        location: 'San Francisco, CA',
      ),
    ];
    _resume.customSections = <Map<String, GenericEntry>>[
      <String, GenericEntry>{
        'Projects': GenericEntry(
            title: 'Inventory Management System',
            description:
                '• Developed a mobile application for a local business to manage their inventory and sales.\n• Utilized Flutter and Firebase to create a cross-platform application for Android and iOS.\n• Implemented a barcode scanner to scan products and update inventory in real-time.\n• Designed a user interface to display sales and inventory data in a visually appealing manner.'),
      },
      <String, GenericEntry>{
        'Projects': GenericEntry(
            title: 'Project Management System',
            description:
                '• Built a web application to manage and track the progress of projects.\n•  Utilized Flutter and GitHub Pages to create a web application for desktop and mobile.\n')
      }
    ];
  }

  /// The portrait layout of the split view.
  Widget _portraitLayout() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        const InputForm(
          portrait: true,
        ),
        PDFViewer(pdfGenerator: pdfGenerator),
      ],
    );
  }

  /// The landscape layout of the split view.
  Widget _landscapeLayout() {
    return Row(
      children: <Widget>[
        const Expanded(child: InputForm()),
        Expanded(
          child: Stack(
            children: <Widget>[
              PDFViewer(pdfGenerator: pdfGenerator),
              Positioned(
                top: 10,
                right: 10,
                child: _recompileButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A tab bar for switching between the input form and the PDF viewer.
  Widget _tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      tabs: const <Widget>[
        Tab(
          text: Strings.form,
        ),
        Tab(
          text: Strings.preview,
        ),
      ],
    );
  }

  /// A button to save and recompile the resume.
  Widget _recompileButton() {
    return MaterialButton(
      color: Colors.green[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        _resume.formKey.currentState!.save();
      },
      minWidth: 25,
      padding: const EdgeInsets.all(15),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.sync,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            Strings.recompile,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  /// A list tile option for the drawer and popup menu.
  Widget _listOption({
    required BuildContext context,
    required String title,
    required IconData iconData,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(
        iconData,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: onTap,
    );
  }

  /// Displays an about dialog containing information about the project and
  /// more options.
  void _showAboutDialog({required bool portraitMode}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: portraitMode
                ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0)
                : const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Strings.iconPath,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Strings.flutterResumeBuilder,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${projectInfoHandler.version} (${projectInfoHandler.buildNumber})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            content: const Text(
              Strings.projectInfo,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(Strings.moreProjects.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                  RedirectHandler.openUrl(Strings.portfolioUrl);
                },
              ),
              TextButton(
                child: Text(Strings.licenses.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                  showLicensePage(
                    context: context,
                    applicationName: Strings.flutterResumeBuilder,
                    applicationVersion: projectInfoHandler.version,
                    applicationLegalese: Strings.copyRight('2021'),
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(Strings.ok),
              ),
            ],
          );
        });
  }

  /// The action items to display in the drawer or popup menu.
  List<Widget> _actionItems({required bool portraitMode}) {
    if (portraitMode) {
      return <Widget>[
        _listOption(
          context: context,
          title: Strings.downloadPDF,
          iconData: Icons.download,
          onTap: () {
            Navigator.pop(context);
            FileHandler().savePDF(pdfGenerator);
          },
        ),
        _listOption(
          context: context,
          title: Strings.aboutThisProject.toUpperCase(),
          iconData: Icons.info,
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog(portraitMode: portraitMode);
          },
        ),
        _listOption(
          context: context,
          title: Strings.contributeToThisProject.toUpperCase(),
          iconData: Icons.code,
          onTap: () {
            Navigator.pop(context);
            RedirectHandler.openUrl(Strings.sourceCodeUrl);
          },
        ),
        _listOption(
          context: context,
          title: Strings.projectDonation.toUpperCase(),
          iconData: Icons.attach_money,
          onTap: () {
            Navigator.pop(context);
            RedirectHandler.openUrl(Strings.sponsorUrl);
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.download),
        tooltip: Strings.downloadPDF,
        onPressed: () => FileHandler().savePDF(pdfGenerator),
      ),
      IconButton(
        icon: const Icon(Icons.info),
        tooltip: Strings.aboutThisProject.toUpperCase(),
        onPressed: () => _showAboutDialog(portraitMode: portraitMode),
      ),
      PopupMenuButton<String>(
        tooltip: Strings.moreOptions.toUpperCase(),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            child: _listOption(
                context: context,
                title: Strings.contributeToThisProject.toUpperCase(),
                iconData: Icons.code,
                onTap: () {
                  Navigator.pop(context);
                  RedirectHandler.openUrl(Strings.sourceCodeUrl);
                }),
            onTap: () {},
          ),
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            child: _listOption(
              context: context,
              title: Strings.projectDonation.toUpperCase(),
              iconData: Icons.attach_money,
              onTap: () {
                Navigator.pop(context);
                RedirectHandler.openUrl(Strings.sponsorUrl);
              },
            ),
            onTap: () {},
          ),
        ],
      ),
      const SizedBox(width: 10),
    ];
  }

  @override
  void initState() {
    super.initState();
    _populateSampleResume();
    _tabController = TabController(length: 2, vsync: this);
    pdfGenerator = PDFGenerator(resume: _resume);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Resume>.value(
      value: _resume,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Scaffold(
            drawer: orientation == Orientation.landscape
                ? null
                : PortraitDrawer(
                    pdfGenerator: pdfGenerator,
                    actionItems: _actionItems(portraitMode: true),
                  ),
            appBar: AppBar(
              bottom: orientation == Orientation.landscape
                  ? null
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: _tabBar(),
                    ),
              title: Row(
                children: <Widget>[
                  const Text(Strings.resumeBuilder),
                  if (orientation == Orientation.landscape)
                    TextButton(
                      onPressed: () =>
                          RedirectHandler.openUrl(Strings.flutterUrl),
                      child: Text(
                        Strings.poweredByFlutter.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
                ],
              ),
              actions: orientation == Orientation.landscape
                  ? _actionItems(portraitMode: false)
                  : null,
              centerTitle: false,
            ),
            body: Consumer<Resume>(
              builder: (BuildContext context, Resume resume, Widget? child) {
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
                    child: orientation == Orientation.portrait
                        ? _portraitLayout()
                        : _landscapeLayout(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// The intent to recompile the resume.
class RecompileIntent extends Intent {
  const RecompileIntent();
}
