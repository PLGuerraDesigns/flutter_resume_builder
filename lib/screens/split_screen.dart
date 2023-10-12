import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/sample_resume.dart';
import '../common/strings.dart';
import '../models/resume.dart';
import '../services/file_handler.dart';
import '../services/pdf_generator.dart';
import '../services/project_info.dart';
import '../services/redirect_handler.dart';
import '../widgets/portrait_drawer.dart';
import 'input_form.dart';
import 'pdf_viewer.dart';

/// Split view of the resume builder (input form and PDF viewer).
class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});
  @override
  State<StatefulWidget> createState() => SplitScreenState();
}

class SplitScreenState extends State<SplitScreen>
    with TickerProviderStateMixin {
  /// The resume to use.
  Resume _resume = SampleResume();

  /// The project info handler.
  ProjectVersionInfoHandler projectInfoHandler = ProjectVersionInfoHandler();

  /// The PDF generator.
  late PDFGenerator pdfGenerator;

  /// The tab controller.
  TabController? _tabController;

  /// The form scroll controller.
  final ScrollController _formScrollController = ScrollController();

  /// The portrait layout of the split view.
  Widget _portraitLayout() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        ResumeInputForm(
          scrollController: _formScrollController,
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
        Expanded(
            child: ResumeInputForm(
          scrollController: _formScrollController,
        )),
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
                      projectInfoHandler.fullVersion,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            content: Text(
              Strings.projectInfo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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
          title: Strings.importResume.toUpperCase(),
          iconData: Icons.upload,
          onTap: () {
            Navigator.pop(context);
            FileHandler().importResume().then((dynamic result) {
              if (result != null) {
                setState(() {
                  _resume = Resume.fromMap(
                      (result as Map<String, dynamic>)['resume']
                          as Map<String, dynamic>);
                  pdfGenerator = PDFGenerator(resume: _resume);
                });
              }
            });
          },
        ),
        _listOption(
          context: context,
          title: Strings.downloadFiles,
          iconData: Icons.download,
          onTap: () {
            Navigator.pop(context);
            FileHandler().downloadFiles(
                pdfGenerator: pdfGenerator,
                projectVersionInfoHandler: projectInfoHandler);
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
          title: Strings.contributeCode.toUpperCase(),
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
        tooltip: Strings.downloadFiles,
        onPressed: () => FileHandler().downloadFiles(
          pdfGenerator: pdfGenerator,
          projectVersionInfoHandler: projectInfoHandler,
        ),
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
                title: Strings.contributeCode.toUpperCase(),
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
                    projectVersionInfoHandler: projectInfoHandler,
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
