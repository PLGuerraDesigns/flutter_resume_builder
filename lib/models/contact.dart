import 'package:flutter/cupertino.dart';

/// A contact entry.
class Contact {
  Contact({
    String? value,
    IconData? iconData,
  }) {
    textController.text = value ?? '';
    this.iconData = iconData ?? CupertinoIcons.minus;
  }

  /// Return a contact from a map.
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      value: map['value'] as String,
      iconData: IconData(map['iconData'] as int,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage),
    );
  }

  /// The controller for the text field.
  TextEditingController textController = TextEditingController();

  /// The icon to display for this contact.
  late IconData iconData;

  /// Return a map of the contact.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': textController.text,
      'iconData': iconData.codePoint,
    };
  }
}
