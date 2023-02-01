import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.name,
    required this.onSubmitted,
    required this.padding,
    this.maxLines = 1,
    this.roundedCorners = true,
    this.initialValue = '',
  });

  final String label;
  final String name;
  final int maxLines;
  final bool roundedCorners;
  final String initialValue;
  final EdgeInsets padding;
  final Function(String?)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FormBuilderTextField(
        name: name,
        maxLines: maxLines,
        initialValue: initialValue,
        style: const TextStyle(color: Colors.white70),
        decoration: roundedCorners
            ? InputDecoration(
                label: Text(label),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : InputDecoration(
                label: Text(label),
                border: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.only(top: 5),
              ),
        onSubmitted: onSubmitted,
        onSaved: onSubmitted,
      ),
    );
  }
}
