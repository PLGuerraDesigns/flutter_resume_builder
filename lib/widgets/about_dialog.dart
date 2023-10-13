import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../services/project_info.dart';
import '../services/redirect_handler.dart';

/// Displays information about the project with actions.
class CustomAboutDialog extends StatelessWidget {
  const CustomAboutDialog({
    super.key,
    required this.projectInfoHandler,
  });

  /// The project version info handler.
  final ProjectVersionInfoHandler projectInfoHandler;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
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
              applicationLegalese: Strings.copyRight('2023'),
            );
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.ok),
        ),
      ],
    );
  }
}
