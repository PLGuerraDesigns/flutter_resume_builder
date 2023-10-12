import 'package:flutter/cupertino.dart';

/// A education history entry.
class Education extends ChangeNotifier {
  Education({
    String? institution,
    String? degree,
    String? startDate,
    String? endDate,
    String? location,
  }) {
    institutionController.text = institution ?? '';
    degreeController.text = degree ?? '';
    startDateController.text = startDate ?? '';
    endDateController.text = endDate ?? '';
    locationController.text = location ?? '';
  }

  /// Return an education instance from a map.
  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'] as String,
      degree: map['degree'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      location: map['location'] as String,
    );
  }

  /// The controller for the institution field.
  TextEditingController institutionController = TextEditingController();

  /// The controller for the degree field.
  TextEditingController degreeController = TextEditingController();

  /// The controller for the start date field.
  TextEditingController startDateController = TextEditingController();

  /// The controller for the end date field.
  TextEditingController endDateController = TextEditingController();

  /// The controller for the location field.
  TextEditingController locationController = TextEditingController();

  /// Return a map of the education history entry.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'institution': institutionController.text,
      'degree': degreeController.text,
      'startDate': startDateController.text,
      'endDate': endDateController.text,
      'location': locationController.text,
    };
  }
}
