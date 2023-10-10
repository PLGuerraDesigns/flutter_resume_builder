import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../models/education.dart';
import 'date_range_entry.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for an education entry.
class EducationEntry extends StatefulWidget {
  const EducationEntry({
    super.key,
    required this.education,
    required this.onSubmitted,
  });

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// The education to use.
  final Education education;

  @override
  State<StatefulWidget> createState() => EducationEntryState();
}

class EducationEntryState extends State<EducationEntry> {
  /// The callback when the user submits the text field.
  Function(String?)? get onSubmitted => widget.onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FrostedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Expanded(
                  child: GenericTextField(
                    label: Strings.institution,
                    controller: widget.education.institutionController,
                    onSubmitted: onSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DateRangeEntry(
                    startDateController: widget.education.startDateController,
                    endDateController: widget.education.endDateController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: GenericTextField(
                    label: Strings.degree,
                    controller: widget.education.degreeController,
                    onSubmitted: onSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GenericTextField(
                    label: Strings.location,
                    controller: widget.education.locationController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
