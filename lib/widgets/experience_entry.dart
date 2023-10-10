import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../models/experience.dart';
import 'date_range_entry.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for an experience entry.
class ExperienceEntry extends StatefulWidget {
  const ExperienceEntry({
    super.key,
    required this.experience,
    required this.onSubmitted,
  });

  /// The experience to use.
  final Experience experience;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  @override
  State<StatefulWidget> createState() => ExperienceEntryState();
}

class ExperienceEntryState extends State<ExperienceEntry> {
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
                    label: Strings.position,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.positionController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DateRangeEntry(
                    startDateController: widget.experience.startDateController,
                    endDateController: widget.experience.endDateController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: GenericTextField(
                    label: Strings.company,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.companyController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GenericTextField(
                    label: Strings.location,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.locationController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GenericTextField(
              label: Strings.jobDescription,
              controller: widget.experience.descriptionController,
              multiLine: true,
              onSubmitted: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
