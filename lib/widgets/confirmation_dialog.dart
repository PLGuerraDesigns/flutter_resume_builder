import 'package:flutter/material.dart';

import '../common/strings.dart';

/// A confirmation dialog that prompts the user to confirm an action.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
  });

  /// The title of the dialog.
  final String title;

  /// The content of the dialog.
  final String content;

  /// The text for the confirm button.
  final String confirmText;

  /// The callback when the user confirms.
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Strings.cancel.toUpperCase()),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          child: Text(
            confirmText.toUpperCase(),
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
