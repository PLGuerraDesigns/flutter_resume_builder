import 'package:flutter/cupertino.dart';

/// A professional experience entry.
class Experience {
  Experience({
    String? company,
    String? position,
    String? startDate,
    String? endDate,
    String? location,
    String? description,
  }) {
    companyController.text = company ?? '';
    positionController.text = position ?? '';
    startDateController.text = startDate ?? '';
    endDateController.text = endDate ?? '';
    locationController.text = location ?? '';
    descriptionController.text = description ?? '';
  }

  /// Return an experience instance from a map.
  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      company: map['company'] as String,
      position: map['position'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
    );
  }

  /// The controller for the company field.
  TextEditingController companyController = TextEditingController();

  /// The controller for the position field.
  TextEditingController positionController = TextEditingController();

  /// The controller for the start date field.
  TextEditingController startDateController = TextEditingController();

  /// The controller for the end date field.
  TextEditingController endDateController = TextEditingController();

  /// The controller for the location field.
  TextEditingController locationController = TextEditingController();

  /// The controller for the description field.
  TextEditingController descriptionController = TextEditingController();

  /// Whether the entry is visible.
  bool _visible = true;

  /// Whether the entry is visible.
  bool get visible => _visible;

  /// Toggle the visibility of the entry.
  void toggleVisibility() {
    _visible = !_visible;
  }

  /// Return a map of the experience.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'company': companyController.text,
      'position': positionController.text,
      'startDate': startDateController.text,
      'endDate': endDateController.text,
      'location': locationController.text,
      'description': descriptionController.text,
    };
  }
}
