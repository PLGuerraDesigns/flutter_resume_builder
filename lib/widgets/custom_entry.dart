import 'package:flutter/material.dart';

import '../common/strings.dart';
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
    required this.portrait,
  });

  /// The generic section to use.
  final GenericEntry genericSection;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// Whether the layout is portrait or not.
  final bool portrait;

  @override
  State<StatefulWidget> createState() => CustomEntryState();
}

class CustomEntryState extends State<CustomEntry> {
  /// The callback when the user submits the text field.
  Function(String?)? get onSubmitted => widget.onSubmitted;

  // Returns the layout based on the orientation.
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
                    label: Strings.title,
                    onSubmitted: onSubmitted,
                    controller: widget.genericSection.titleController,
                  ),
                ),
                const SizedBox(width: 10, height: 10),
                Flexible(
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
            _responsiveLayout(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: GenericTextField(
                    label: Strings.subtitle,
                    onSubmitted: onSubmitted,
                    controller: widget.genericSection.subtitleController,
                  ),
                ),
                const SizedBox(width: 10, height: 10),
                Flexible(
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
