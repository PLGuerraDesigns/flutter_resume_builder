import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/strings.dart';
import '../services/pdf_generator.dart';

/// A drawer that is displayed in portrait mode.
class PortraitDrawer extends StatelessWidget {
  const PortraitDrawer({
    super.key,
    required this.pdfGenerator,
    required this.actionItems,
  });

  /// The PDF generator.
  final PDFGenerator pdfGenerator;

  /// The action items to display in the drawer.
  final List<Widget> actionItems;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  Strings.iconPath,
                  height: 50,
                ),
                TextButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(Strings.flutterUrl))) {
                      launchUrl(
                        Uri.parse(Strings.flutterUrl),
                      );
                    }
                  },
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
          ),
          ...actionItems
        ],
      ),
    );
  }
}
