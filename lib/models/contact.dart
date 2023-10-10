import 'package:flutter/cupertino.dart';

/// A contact entry.
class Contact {
  Contact({
    String value = '',
    this.iconData = CupertinoIcons.phone,
  }) {
    textController.text = value;
  }

  /// The controller for the text field.
  TextEditingController textController = TextEditingController();

  /// The icon to display for this contact.
  IconData iconData = CupertinoIcons.phone;
}
