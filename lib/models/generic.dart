import 'package:flutter/cupertino.dart';

/// A generic entry that can be used for custom sections.
class GenericEntry extends ChangeNotifier {
  GenericEntry({
    String title = '',
    String subtitle = '',
    String startDate = '',
    String endDate = '',
    String location = '',
    String description = '',
  }) {
    titleController.text = title;
    subtitleController.text = subtitle;
    startDateController.text = startDate;
    endDateController.text = endDate;
    locationController.text = location;
    descriptionController.text = description;
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
}
