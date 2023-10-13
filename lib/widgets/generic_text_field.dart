import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A generic form text field.
class GenericTextField extends StatefulWidget {
  const GenericTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.onSubmitted,
    this.enabled = true,
    this.multiLine = false,
    this.roundedStyling = true,
  });

  /// The label for the text field.
  final String label;

  /// The controller for the text field.
  final TextEditingController controller;

  /// Whether to use the rounded styling.
  final bool roundedStyling;

  /// Whether the text field is multi-line.
  final bool multiLine;

  /// The callback when the user submits the text field.
  final Function(String?)? onSubmitted;

  /// Whether the text field is enabled.
  final bool enabled;

  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: UniqueKey().toString(),
      minLines: widget.multiLine ? 2 : 1,
      maxLines: widget.multiLine || widget.multiLine ? 15 : 1,
      controller: widget.controller,
      enabled: widget.enabled,
      style: !widget.roundedStyling
          ? const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          : const TextStyle(fontSize: 14),
      decoration: widget.roundedStyling
          ? InputDecoration(
              label: Text(widget.label),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : InputDecoration(
              label: Text(widget.label),
              border: const UnderlineInputBorder(),
              contentPadding: EdgeInsets.zero,
            ),
      onSubmitted: widget.onSubmitted,
      onSaved: widget.onSubmitted,
    );
  }
}
