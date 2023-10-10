import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../models/generic.dart';
import 'date_range_entry.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for a generic entry.
class CustomEntry extends StatefulWidget {
  const CustomEntry({
    super.key,
    required this.genericSection,
    required this.onSubmitted,
  });

  /// The generic section to use.
  final GenericEntry genericSection;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  @override
  State<StatefulWidget> createState() => CustomEntryState();
}

class CustomEntryState extends State<CustomEntry> {
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
                    label: Strings.title,
                    onSubmitted: onSubmitted,
                    controller: widget.genericSection.titleController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DateRangeEntry(
                    startDateController:
                        widget.genericSection.startDateController,
                    endDateController: widget.genericSection.endDateController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: GenericTextField(
                    label: Strings.subtitle,
                    onSubmitted: onSubmitted,
                    controller: widget.genericSection.subtitleController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GenericTextField(
                    label: Strings.location,
                    controller: widget.genericSection.locationController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GenericTextField(
              label: Strings.description,
              controller: widget.genericSection.descriptionController,
              multiLine: true,
              onSubmitted: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
