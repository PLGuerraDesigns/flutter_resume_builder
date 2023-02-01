import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/experience.dart';
import 'package:flutter_resume_builder/widgets/custom_icon_button.dart';
import 'package:flutter_resume_builder/widgets/form_text_field.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExperienceFormField extends StatefulWidget {
  const ExperienceFormField({
    Key? key,
    required this.id,
    required this.experience,
    required this.onIconButtonPressed,
  }) : super(key: key);

  final int id;
  final Experience experience;
  final Function()? onIconButtonPressed;

  @override
  State<StatefulWidget> createState() => ExperienceFormFieldState();
}

class ExperienceFormFieldState extends State<ExperienceFormField> {
  bool editingStartDate = true;
  Function(Object?)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CustomIconButton(
                iconData: widget.experience.iconData,
                imageURL: widget.experience.imageURL,
                showImage: widget.experience.showImage,
                onPressed: widget.onIconButtonPressed,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormTextField(
                  label: Strings.position,
                  name: '${Strings.position}${widget.id}',
                  padding: const EdgeInsets.only(bottom: 5),
                  onSubmitted: (value) {
                    widget.experience.position = value.toString();
                  },
                  roundedCorners: false,
                  initialValue: widget.experience.position,
                ),
                FormTextField(
                  label: Strings.company,
                  name: '${Strings.company}${widget.id}',
                  padding: const EdgeInsets.all(0),
                  onSubmitted: (value) {
                    widget.experience.company = value.toString();
                  },
                  roundedCorners: false,
                  initialValue: widget.experience.company,
                ),
                const SizedBox(height: 10),
                _startAndEndDate(),
                const SizedBox(height: 10),
                FormTextField(
                  label: Strings.jobDescription,
                  name: '${Strings.jobDescription}${widget.id}',
                  initialValue: widget.experience.description,
                  maxLines: 5,
                  padding: const EdgeInsets.only(top: 5),
                  onSubmitted: (value) {
                    widget.experience.description = value.toString();
                  },
                ),
              ],
            ))
          ],
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
                DateFormat('MMM yyyy').format(widget.experience.startDate),
                editingStartDate && onSubmit != null, () {
              setState(() {
                editingStartDate = true;
                onSubmit = (dateTime) {
                  widget.experience.startDate =
                      DateTime.parse(dateTime.toString());
                  onSubmit = null;
                };
              });
            }),
            const SizedBox(
                width: 20,
                child: Divider(
                  indent: 6,
                  endIndent: 6,
                  color: Colors.white,
                )),
            _datePickerButton(
              DateFormat('MMM yyyy').format(widget.experience.endDate),
              !editingStartDate && onSubmit != null,
              () {
                setState(() {
                  editingStartDate = false;
                  onSubmit = (dateTime) {
                    widget.experience.endDate =
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
