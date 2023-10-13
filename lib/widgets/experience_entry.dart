import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../models/experience.dart';
import 'date_range_entry.dart';
import 'edit_entry_menu.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for an experience entry.
class ExperienceEntry extends StatefulWidget {
  const ExperienceEntry({
    super.key,
    required this.experience,
    required this.rebuild,
    required this.onRemove,
    required this.portrait,
  });

  /// The experience to use.
  final Experience experience;

  /// The callback when the user submits the text field or edits the visibility.
  final Function()? rebuild;

  final Function()? onRemove;

  /// Whether the layout is portrait or not.
  final bool portrait;

  @override
  State<StatefulWidget> createState() => ExperienceEntryState();
}

class ExperienceEntryState extends State<ExperienceEntry> {
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
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.experience.visible ? 1 : 0.75,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FrostedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              EditEntryMenu(
                visible: widget.experience.visible,
                onRemove: widget.onRemove,
                onToggleVisibility: () {
                  widget.experience.toggleVisibility();
                  widget.rebuild?.call();
                },
              ),
              const SizedBox(height: 4),
              _responsiveLayout(
                children: <Widget>[
                  Flexible(
                    child: GenericTextField(
                      label: Strings.position,
                      onSubmitted: (_) => widget.rebuild,
                      controller: widget.experience.positionController,
                      enabled: widget.experience.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: DateRangeEntry(
                      startDateController:
                          widget.experience.startDateController,
                      endDateController: widget.experience.endDateController,
                      onSubmitted: (_) => widget.rebuild,
                      enableEditing: widget.experience.visible,
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
                      onSubmitted: (_) => widget.rebuild,
                      controller: widget.experience.companyController,
                      enabled: widget.experience.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: GenericTextField(
                      label: Strings.location,
                      onSubmitted: (_) => widget.rebuild,
                      controller: widget.experience.locationController,
                      enabled: widget.experience.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GenericTextField(
                label: Strings.jobDescription,
                controller: widget.experience.descriptionController,
                multiLine: true,
                onSubmitted: (_) => widget.rebuild,
                enabled: widget.experience.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
