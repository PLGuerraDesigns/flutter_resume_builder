import 'package:flutter/material.dart';

import '../common/strings.dart';
import 'confirmation_dialog.dart';

/// A menu for removing or hiding an entry.
class EditEntryMenu extends StatelessWidget {
  const EditEntryMenu({
    super.key,
    required this.onRemove,
    required this.onToggleVisibility,
    required this.visible,
  });

  /// Whether the entry is visible.
  final bool visible;

  /// The callback when the user removes the entry.
  final Function()? onRemove;

  /// The callback when the user toggles the visibility of the entry.
  final Function()? onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const SizedBox(width: 4),
        Icon(
          Icons.drag_indicator_outlined,
          size: 18,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmationDialog(
                title: Strings.removeEntry,
                content: Strings.removeEntryWarning,
                confirmText: Strings.remove,
                onConfirm: onRemove,
              ),
            );
          },
          tooltip: Strings.removeEntry,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          iconSize: 18,
          icon: const Icon(Icons.delete_outline),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onToggleVisibility,
          tooltip: visible ? Strings.hideEntry : Strings.showEntry,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          iconSize: 18,
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
        ),
      ],
    );
  }
}
