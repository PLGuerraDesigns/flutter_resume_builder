import 'package:flutter/material.dart';
import '../common/strings.dart';
import 'generic_text_field.dart';

/// A form field for a date range.
class DateRangeEntry extends StatelessWidget {
  const DateRangeEntry({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.onSubmitted,
    required this.enableEditing,
  });

  /// The controller for the start date.
  final TextEditingController startDateController;

  /// The controller for the end date.
  final TextEditingController endDateController;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// Whether the text fields are enabled.
  final bool enableEditing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GenericTextField(
            controller: startDateController,
            label: Strings.startDate,
            onSubmitted: onSubmitted,
            enabled: enableEditing,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '-',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(enableEditing ? 0.5 : 0.25),
            ),
          ),
        ),
        Expanded(
          child: GenericTextField(
            controller: endDateController,
            label: Strings.endDate,
            onSubmitted: onSubmitted,
            enabled: enableEditing,
          ),
        ),
      ],
    );
  }
}
