import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/contact.dart';
import 'package:flutter_resume_builder/widgets/form_text_field.dart';
import 'package:flutter_resume_builder/widgets/custom_icon_button.dart';

class ContactFormField extends StatelessWidget {
  const ContactFormField({
    Key? key,
    required this.contact,
    required this.onSubmitted,
    required this.onPressed,
    required this.id,
    required this.padding,
    this.initialValue = '',
  }) : super(key: key);

  final int id;
  final Contact contact;
  final String initialValue;
  final Function(String?)? onSubmitted;
  final Function()? onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          iconData: contact.iconData,
          imageURL: contact.imageURL,
          showImage: contact.showImage,
          onPressed: onPressed,
        ),
        const SizedBox(width: 5),
        Expanded(
            child: FormTextField(
          name: '${Strings.contact}$id',
          label: Strings.contact,
          initialValue: initialValue,
          padding: padding,
          onSubmitted: onSubmitted,
        ))
      ],
    );
  }
}
