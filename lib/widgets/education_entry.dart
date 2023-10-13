import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../models/education.dart';
import 'date_range_entry.dart';
import 'edit_entry_menu.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for an education entry.
class EducationEntry extends StatefulWidget {
  const EducationEntry({
    super.key,
    required this.education,
    required this.rebuild,
    required this.portrait,
    required this.onRemove,
  });

  /// The callback when the user submits the text field or edits the visibility.
  final Function()? rebuild;

  /// The education to use.
  final Education education;

  /// Whether the layout is portrait or not.
  final bool portrait;

  /// The callback when the user removes the entry.
  final Function()? onRemove;

  @override
  State<StatefulWidget> createState() => EducationEntryState();
}

class EducationEntryState extends State<EducationEntry> {
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
    return Opacity(
      opacity: widget.education.visible ? 1 : 0.75,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FrostedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              EditEntryMenu(
                onRemove: widget.onRemove,
                onToggleVisibility: () {
                  widget.education.toggleVisibility();
                  widget.rebuild?.call();
                },
                visible: widget.education.visible,
              ),
              const SizedBox(height: 4),
              _responsiveLayout(
                children: <Widget>[
                  Flexible(
                    child: GenericTextField(
                      label: Strings.institution,
                      controller: widget.education.institutionController,
                      onSubmitted: (_) => widget.rebuild,
                      enabled: widget.education.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: DateRangeEntry(
                      startDateController: widget.education.startDateController,
                      endDateController: widget.education.endDateController,
                      onSubmitted: (_) => widget.rebuild,
                      enableEditing: widget.education.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _responsiveLayout(
                children: <Widget>[
                  Flexible(
                    child: GenericTextField(
                      label: Strings.degree,
                      controller: widget.education.degreeController,
                      onSubmitted: (_) => widget.rebuild,
                      enabled: widget.education.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: GenericTextField(
                      label: Strings.location,
                      controller: widget.education.locationController,
                      onSubmitted: (_) => widget.rebuild,
                      enabled: widget.education.visible,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
