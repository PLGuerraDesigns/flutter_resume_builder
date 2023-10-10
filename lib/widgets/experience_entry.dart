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
    required this.portrait,
  });

  /// The experience to use.
  final Experience experience;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// Whether the layout is portrait or not.
  final bool portrait;

  @override
  State<StatefulWidget> createState() => ExperienceEntryState();
}

class ExperienceEntryState extends State<ExperienceEntry> {
  /// The callback when the user submits the text field.
  Function(String?)? get onSubmitted => widget.onSubmitted;

  /// Returns the layout based on the orientation.
  Widget _responsiveLayout({required List<Widget> children}) {
    if (widget.portrait) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FrostedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 4),
            _responsiveLayout(
              children: <Widget>[
                Flexible(
                  child: GenericTextField(
                    label: Strings.position,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.positionController,
                  ),
                ),
                const SizedBox(width: 10, height: 10),
                Flexible(
                  child: DateRangeEntry(
                    startDateController: widget.experience.startDateController,
                    endDateController: widget.experience.endDateController,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _responsiveLayout(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: GenericTextField(
                    label: Strings.company,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.companyController,
                  ),
                ),
                const SizedBox(width: 10, height: 10),
                Flexible(
                  child: GenericTextField(
                    label: Strings.location,
                    onSubmitted: onSubmitted,
                    controller: widget.experience.locationController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
