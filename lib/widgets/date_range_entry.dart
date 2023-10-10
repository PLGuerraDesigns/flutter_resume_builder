import 'package:flutter/material.dart';
import '../constants/strings.dart';
import 'generic_text_field.dart';

/// A form field for a date range.
class DateRangeEntry extends StatelessWidget {
  const DateRangeEntry({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.onSubmitted,
  });

  /// The controller for the start date.
  final TextEditingController startDateController;

  /// The controller for the end date.
  final TextEditingController endDateController;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GenericTextField(
            controller: startDateController,
            label: Strings.startDate,
            onSubmitted: onSubmitted,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('-'),
        ),
        Expanded(
          child: GenericTextField(
            controller: endDateController,
            label: Strings.endDate,
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}
