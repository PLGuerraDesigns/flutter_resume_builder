import 'package:flutter/cupertino.dart';

/// A generic entry that can be used for custom sections.
class GenericEntry {
  GenericEntry({
    String? title,
    String? subtitle,
    String? startDate,
    String? endDate,
    String? location,
    String? description,
  }) {
    titleController.text = title ?? '';
    subtitleController.text = subtitle ?? '';
    startDateController.text = startDate ?? '';
    endDateController.text = endDate ?? '';
    locationController.text = location ?? '';
    descriptionController.text = description ?? '';
  }

  /// Return a generic entry from a map.
  factory GenericEntry.fromMap(Map<String, dynamic> map) {
    return GenericEntry(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
    );
  }

  /// The controller for the title field.
  TextEditingController titleController = TextEditingController();

  /// The controller for the subtitle field.
  TextEditingController subtitleController = TextEditingController();

  /// The controller for the start date field.
  TextEditingController startDateController = TextEditingController();

  /// The controller for the end date field.
  TextEditingController endDateController = TextEditingController();

  /// The controller for the description field.
  TextEditingController descriptionController = TextEditingController();

  /// The controller for the location field.
  TextEditingController locationController = TextEditingController();

  /// Whether the entry is visible.
  bool _visible = true;

  /// Whether the entry is visible.
  bool get visible => _visible;

  /// Toggle the visibility of the entry.
  void toggleVisibility() {
    _visible = !_visible;
  }

  /// Return a map of the generic entry.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'startDate': startDateController.text,
      'endDate': endDateController.text,
      'location': locationController.text,
      'description': descriptionController.text,
    };
  }
}
