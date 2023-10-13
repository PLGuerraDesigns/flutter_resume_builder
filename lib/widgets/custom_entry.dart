import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../models/generic.dart';
import 'date_range_entry.dart';
import 'edit_entry_menu.dart';
import 'frosted_container.dart';
import 'generic_text_field.dart';

/// A form field for a generic entry.
class CustomEntry extends StatefulWidget {
  const CustomEntry({
    super.key,
    required this.genericSection,
    required this.onRemove,
    required this.onSubmitted,
    required this.portrait,
    required this.enableEditing,
  });

  /// The generic section to use.
  final GenericEntry genericSection;

  final Function()? onRemove;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// Whether the layout is portrait or not.
  final bool portrait;

  /// Whether the text fields are enabled.
  final bool enableEditing;

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
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.genericSection.visible ? 1 : 0.75,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FrostedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              EditEntryMenu(
                visible: widget.genericSection.visible,
                onRemove: widget.enableEditing ? widget.onRemove : null,
                onToggleVisibility: widget.enableEditing
                    ? () => setState(widget.genericSection.toggleVisibility)
                    : null,
              ),
              const SizedBox(height: 4),
              _responsiveLayout(
                children: <Widget>[
                  Flexible(
                    child: GenericTextField(
                      label: Strings.title,
                      onSubmitted: onSubmitted,
                      controller: widget.genericSection.titleController,
                      enabled:
                          widget.enableEditing && widget.genericSection.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: DateRangeEntry(
                      startDateController:
                          widget.genericSection.startDateController,
                      endDateController:
                          widget.genericSection.endDateController,
                      onSubmitted: onSubmitted,
                      enableEditing:
                          widget.enableEditing && widget.genericSection.visible,
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
                      enabled:
                          widget.enableEditing && widget.genericSection.visible,
                    ),
                  ),
                  const SizedBox(width: 10, height: 10),
                  Flexible(
                    child: GenericTextField(
                      label: Strings.location,
                      controller: widget.genericSection.locationController,
                      onSubmitted: onSubmitted,
                      enabled:
                          widget.enableEditing && widget.genericSection.visible,
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
                enabled: widget.enableEditing && widget.genericSection.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
