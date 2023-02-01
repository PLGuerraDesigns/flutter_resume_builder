import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/education.dart';
import 'package:flutter_resume_builder/widgets/custom_icon_button.dart';
import 'package:flutter_resume_builder/widgets/form_text_field.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EducationFormField extends StatefulWidget {
  const EducationFormField({
    super.key,
    required this.id,
    required this.education,
    required this.onIconButtonPressed,
    required this.padding,
  });

  final int id;
  final Education education;
  final Function()? onIconButtonPressed;
  final EdgeInsets padding;

  @override
  State<StatefulWidget> createState() => EducationFormFieldState();
}

class EducationFormFieldState extends State<EducationFormField> {
  bool editingStartDate = true;
  Function(Object?)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: widget.padding,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CustomIconButton(
                  iconData: widget.education.iconData,
                  imageURL: widget.education.imageURL,
                  showImage: widget.education.showImage,
                  onPressed: widget.onIconButtonPressed,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: [
                    FormTextField(
                      label: Strings.institution,
                      name: '${Strings.institution}${widget.id}',
                      initialValue: widget.education.institution,
                      padding: const EdgeInsets.only(bottom: 5),
                      onSubmitted: (value) {
                        widget.education.institution = value.toString();
                      },
                      roundedCorners: false,
                    ),
                    FormTextField(
                      label: Strings.degree,
                      name: '${Strings.degree}${widget.id}',
                      initialValue: widget.education.degree,
                      padding: const EdgeInsets.all(0),
                      onSubmitted: (value) {
                        widget.education.degree = value.toString();
                      },
                      roundedCorners: false,
                    ),
                    const SizedBox(height: 10),
                    _startAndEndDate(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startAndEndDate() {
    return Column(
      children: [
        Row(
          children: [
            _datePickerButton(
                DateFormat('MMM yyyy').format(widget.education.startDate),
                editingStartDate && onSubmit != null, () {
              setState(() {
                editingStartDate = true;
                onSubmit = (dateTime) {
                  widget.education.startDate =
                      DateTime.parse(dateTime.toString());
                  onSubmit = null;
                };
              });
            }),
            const SizedBox(
                width: 20,
                child: Divider(
                  indent: 5,
                  endIndent: 5,
                  color: Colors.white,
                )),
            _datePickerButton(
              DateFormat('MMM yyyy').format(widget.education.endDate),
              !editingStartDate && onSubmit != null,
              () {
                setState(() {
                  editingStartDate = false;
                  onSubmit = (dateTime) {
                    widget.education.endDate =
                        DateTime.parse(dateTime.toString());
                    onSubmit = null;
                  };
                });
              },
            )
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          child: onSubmit != null
              ? SfDateRangePicker(
                  view: DateRangePickerView.decade,
                  showNavigationArrow: true,
                  showActionButtons: true,
                  showTodayButton: true,
                  maxDate: DateTime.now(),
                  onSubmit: onSubmit,
                  toggleDaySelection: false,
                  selectionTextStyle: const TextStyle(color: Colors.white),
                  headerHeight: 60,
                  onCancel: () {
                    setState(() {
                      onSubmit = null;
                    });
                  },
                )
              : Container(),
        ),
      ],
    );
  }

  Widget _datePickerButton(String text, bool selected, Function()? onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
            width: selected ? 1.5 : 1,
            color: selected ? Colors.blue : Colors.white38),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: selected ? Colors.blue : Colors.white70),
      ),
    );
  }
}
