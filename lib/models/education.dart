import 'package:flutter/cupertino.dart';

/// A education history entry.
class Education extends ChangeNotifier {
  Education({
    String institution = '',
    String degree = '',
    String startDate = '',
    String endDate = '',
    String location = '',
  }) {
    institutionController.text = institution;
    degreeController.text = degree;
    startDateController.text = startDate;
    endDateController.text = endDate;
    locationController.text = location;
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
}
