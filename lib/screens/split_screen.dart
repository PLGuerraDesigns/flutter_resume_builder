import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../common/sample_resume.dart';
import '../common/strings.dart';
import '../models/resume.dart';
import '../services/file_handler.dart';
import '../services/pdf_generator.dart';
import '../services/project_info.dart';
import '../services/redirect_handler.dart';
import '../widgets/about_dialog.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/download_dialog.dart';
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
        PDFViewer(
          pdfGenerator: pdfGenerator,
        ),
      ],
    );
  }

  /// The navigation rail for landscape mode.
  Widget _navigationRail() {
    String firstWordOnly(String text) => text.split(' ').first.toUpperCase();

    return NavigationRail(
      selectedIndex: 0,
      elevation: 12,
      labelType: NavigationRailLabelType.all,
      indicatorColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            {
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmationDialog(
                  title: Strings.clearResume,
                  content: Strings.clearResumeWarning,
                  confirmText: Strings.clear,
                  onConfirm: () {
                    _resume = Resume();
                    pdfGenerator = PDFGenerator(resume: _resume);
                    _formScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    setState(() {});
                  },
                ),
              );
            }
          case 1:
            FileHandler().importResume().then((dynamic result) {
              if (result != null) {
                _resume = Resume.fromMap((result
                    as Map<String, dynamic>)['resume'] as Map<String, dynamic>);
                pdfGenerator = PDFGenerator(resume: _resume);
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Strings.noValidJsonFile,
                        style: Theme.of(context).textTheme.bodyMedium),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red[700],
                  ),
                );
              }
            });
          case 2:
            showDialog(
              context: context,
              builder: (BuildContext context) => DownloadDialog(
                onDownloadPdf: () async {
                  await FileHandler().savePDF(pdfGenerator);
                },
                onDownloadJson: () {
                  FileHandler().saveJSONData(
                    pdfGenerator: pdfGenerator,
                    projectVersionInfoHandler: projectInfoHandler,
                  );
                },
              ),
            );
          case 3:
            Printing.layoutPdf(
                onLayout: (PdfPageFormat format) =>
                    pdfGenerator.generateResumeAsPDF());
          case 4:
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAboutDialog(
                    projectInfoHandler: projectInfoHandler,
                  );
                });
          case 5:
            RedirectHandler.openUrl(Strings.sourceCodeUrl);
          case 6:
            RedirectHandler.openUrl(Strings.sponsorUrl);
        }
      },
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon: const Tooltip(
              message: Strings.clearResume, child: Icon(Icons.restart_alt)),
          label: Text(
            firstWordOnly(Strings.clearResume),
          ),
        ),
        NavigationRailDestination(
          icon: const Tooltip(
            message: Strings.importJson,
            child: Icon(Icons.upload_file),
          ),
          label: Text(
            firstWordOnly(Strings.importJson),
          ),
        ),
        NavigationRailDestination(
          icon: const Tooltip(
            message: Strings.downloadPdfAndJson,
            child: Icon(Icons.download),
          ),
          label: Text(
            firstWordOnly(Strings.downloadPdfAndJson),
          ),
        ),
        NavigationRailDestination(
          icon: const Tooltip(
            message: Strings.printPDF,
            child: Icon(Icons.print),
          ),
          label: Text(
            firstWordOnly(Strings.printPDF),
          ),
        ),
        NavigationRailDestination(
          icon: const Tooltip(
            message: Strings.aboutThisProject,
            child: Icon(Icons.info),
          ),
          label: Text(
            firstWordOnly(Strings.aboutThisProject),
          ),
        ),
        NavigationRailDestination(
          icon: const Tooltip(
            message: Strings.contributeCode,
            child: Icon(Icons.code),
          ),
          label: Text(
            firstWordOnly(Strings.contributeCode),
          ),
        ),
      ],
    );
  }

  /// The landscape layout of the split view.
  Widget _landscapeLayout() {
    return Row(
      children: <Widget>[
        _navigationRail(),
        Expanded(
          child: ResumeInputForm(
            scrollController: _formScrollController,
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              PDFViewer(
                key: GlobalKey(),
                pdfGenerator: pdfGenerator,
              ),
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
    return Tooltip(
      message: Strings.recompileShortCut,
      child: MaterialButton(
        color: Colors.green[700]!.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          _resume.formKey.currentState!.save();
        },
        minWidth: 25,
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.sync,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              Strings.recompile.toUpperCase(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
          ],
        ),
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

  /// The action items to display in the drawer
  List<Widget> _drawerActions() {
    return <Widget>[
      _listOption(
        context: context,
        title: Strings.printPDF,
        iconData: Icons.print,
        onTap: () async {
          Navigator.pop(context);
          await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) =>
                  pdfGenerator.generateResumeAsPDF());
        },
      ),
      _listOption(
        context: context,
        title: Strings.aboutThisProject.toUpperCase(),
        iconData: Icons.info,
        onTap: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAboutDialog(
                  projectInfoHandler: projectInfoHandler,
                );
              });
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
    return WillPopScope(
      onWillPop: () async => false,
      child: ChangeNotifierProvider<Resume>.value(
        value: _resume,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Scaffold(
              drawer: orientation == Orientation.landscape
                  ? null
                  : PortraitDrawer(
                      pdfGenerator: pdfGenerator,
                      actionItems: _drawerActions(),
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
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                                  ),
                        ),
                      ),
                    const Spacer(),
                    if (orientation == Orientation.portrait)
                      IconButton(
                        icon: const Icon(Icons.restart_alt),
                        tooltip: Strings.clearResume,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                ConfirmationDialog(
                              title: Strings.clearResume,
                              content: Strings.clearResumeWarning,
                              confirmText: Strings.clear,
                              onConfirm: () {
                                _resume = Resume();
                                pdfGenerator = PDFGenerator(resume: _resume);
                                _formScrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    if (orientation == Orientation.portrait)
                      IconButton(
                        icon: const Icon(Icons.upload_file),
                        tooltip: Strings.importJson,
                        onPressed: () {
                          FileHandler().importResume().then((dynamic result) {
                            if (result != null) {
                              setState(() {
                                _resume = Resume.fromMap(
                                    (result as Map<String, dynamic>)['resume']
                                        as Map<String, dynamic>);
                                pdfGenerator = PDFGenerator(resume: _resume);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(Strings.noValidJsonFile,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.red[700],
                                ),
                              );
                            }
                          });
                        },
                      ),
                    if (orientation == Orientation.portrait)
                      IconButton(
                        icon: const Icon(Icons.download),
                        tooltip: Strings.downloadPdfAndJson,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => DownloadDialog(
                              onDownloadPdf: () async {
                                await FileHandler().savePDF(pdfGenerator);
                              },
                              onDownloadJson: () {
                                FileHandler().saveJSONData(
                                  pdfGenerator: pdfGenerator,
                                  projectVersionInfoHandler: projectInfoHandler,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
                centerTitle: false,
              ),
              body: Consumer<Resume>(
                builder: (BuildContext context, Resume resume, Widget? child) {
                  return Shortcuts(
                    shortcuts: <ShortcutActivator, Intent>{
                      LogicalKeySet(LogicalKeyboardKey.meta,
                          LogicalKeyboardKey.enter): const RecompileIntent(),
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
      ),
    );
  }
}

/// The intent to recompile the resume.
class RecompileIntent extends Intent {
  const RecompileIntent();
}
