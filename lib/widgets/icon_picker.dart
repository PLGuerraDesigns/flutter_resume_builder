import 'package:flutter/material.dart';

/// A button that displays an icon. The icon can be changed.
class IconPicker extends StatelessWidget {
  const IconPicker({
    super.key,
    this.iconData,
    required this.onPressed,
  });

  /// The icon to display.
  final IconData? iconData;

  /// The callback when the user presses the button.
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(iconData),
        ),
      ),
    );
  }
}
