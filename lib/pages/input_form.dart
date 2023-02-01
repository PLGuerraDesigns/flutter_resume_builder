import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/models/resume.dart';
import 'package:flutter_resume_builder/widgets/contact_form_field.dart';
import 'package:flutter_resume_builder/widgets/education_form_field.dart';
import 'package:flutter_resume_builder/widgets/experience_form_field.dart';
import 'package:flutter_resume_builder/widgets/icon_image_selection_dialog.dart';

import '../widgets/form_text_field.dart';

class InputForm extends StatefulWidget {
  const InputForm({Key? key, required this.resume}) : super(key: key);

  final Resume resume;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
            key: widget.resume.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  Strings.contactDetails,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                FormTextField(
                  label: Strings.name,
                  name: Strings.name,
                  initialValue: widget.resume.name,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  onSubmitted: (value) {
                    widget.resume.name = value.toString();
                  },
                ),
                FormTextField(
                  label: Strings.location,
                  name: Strings.location,
                  initialValue: widget.resume.location,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  onSubmitted: (value) {
                    widget.resume.location = value.toString();
                  },
                ),
                const SizedBox(height: 10),
                _getContactInfoInputList(),
                const SizedBox(height: 20),
                const Text(
                  Strings.experience,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _getExperienceList(),
                const SizedBox(height: 10),
                const Text(
                  Strings.education,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _getEducationList(),
              ],
            )),
      ),
    );
  }

  Widget _getContactInfoInputList() {
    List<TableRow> contactInfoList = [];
    for (int iterator = 0;
        iterator < widget.resume.contactList.length;
        iterator = iterator + 2) {
      contactInfoList.add(
        TableRow(children: [
          ContactFormField(
            contact: widget.resume.contactList[iterator],
            initialValue: widget.resume.contactList[iterator].details,
            id: iterator,
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              right: 5,
            ),
            onSubmitted: (value) {
              widget.resume.contactList[iterator].details = value.toString();
            },
            onPressed: () => iconImageSelectionPopup(
              iconData: widget.resume.contactList[iterator].iconData,
              imageURL: widget.resume.contactList[iterator].imageURL,
              showImage: widget.resume.contactList[iterator].showImage,
              onCheckmarkButtonPressed: (showImage) {
                widget.resume.contactList[iterator].showImage = showImage;
              },
              onUploadImageButtonPressed: () {},
              onSelectIconButtonPressed: () async {
                IconData? iconData = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackModes: [IconPack.cupertino]);
                if (iconData != null) {
                  widget.resume.contactList[iterator].iconData = iconData;
                }
              },
              onImageURLSubmitted: (value) async {
                bool successful = await widget.resume.contactList[iterator]
                    .loadImage(value.toString());
                // Handles snackbar async gap issue
                if (!mounted) return;

                if (!successful) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      Strings.failedToLoadNetworkImage,
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    backgroundColor: Colors.red[800],
                  ));
                }
              },
            ),
          ),
          iterator + 1 < widget.resume.contactList.length
              ? Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: ContactFormField(
                    contact: widget.resume.contactList[iterator + 1],
                    initialValue:
                        widget.resume.contactList[iterator + 1].details,
                    id: iterator + 1,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    onSubmitted: (value) {
                      widget.resume.contactList[iterator + 1].details =
                          value.toString();
                    },
                    onPressed: () => iconImageSelectionPopup(
                      iconData:
                          widget.resume.contactList[iterator + 1].iconData,
                      imageURL:
                          widget.resume.contactList[iterator + 1].imageURL,
                      showImage:
                          widget.resume.contactList[iterator + 1].showImage,
                      onCheckmarkButtonPressed: (showImage) {
                        widget.resume.contactList[iterator + 1].showImage =
                            showImage;
                      },
                      onUploadImageButtonPressed: () {},
                      onSelectIconButtonPressed: () async {
                        IconData? iconData =
                            await FlutterIconPicker.showIconPicker(context,
                                iconPackModes: [IconPack.cupertino]);
                        if (iconData != null) {
                          widget.resume.contactList[iterator + 1].iconData =
                              iconData;
                        }
                      },
                      onImageURLSubmitted: (value) async {
                        bool successful = await widget
                            .resume.contactList[iterator + 1]
                            .loadImage(value.toString());

                        // Handles snackbar async gap issue
                        if (!mounted) return;

                        if (!successful) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              Strings.failedToLoadNetworkImage,
                              style: TextStyle(color: Colors.grey[100]),
                            ),
                            backgroundColor: Colors.red[800],
                          ));
                        }
                      },
                    ),
                  ),
                )
              : Container(),
        ]),
      );
    }
    return Table(children: contactInfoList);
  }

  Widget _getExperienceList() {
    return Column(
      children: [
        for (int iterator = 0;
            iterator < widget.resume.experienceList.length;
            iterator++)
          ExperienceFormField(
            id: iterator,
            experience: widget.resume.experienceList[iterator],
            onIconButtonPressed: () => iconImageSelectionPopup(
              iconData: widget.resume.experienceList[iterator].iconData,
              imageURL: widget.resume.experienceList[iterator].imageURL,
              showImage: widget.resume.experienceList[iterator].showImage,
              onCheckmarkButtonPressed: (showImage) {
                widget.resume.experienceList[iterator].showImage = showImage;
              },
              onUploadImageButtonPressed: () {},
              onSelectIconButtonPressed: () async {
                IconData? iconData = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackModes: [IconPack.cupertino]);
                if (iconData != null) {
                  widget.resume.experienceList[iterator].iconData = iconData;
                }
              },
              onImageURLSubmitted: (value) async {
                bool successful = await widget.resume.experienceList[iterator]
                    .loadImage(value.toString());
                // Handles snackbar async gap issue
                if (!mounted) return;

                if (!successful) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      Strings.failedToLoadNetworkImage,
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    backgroundColor: Colors.red[800],
                  ));
                }
              },
            ),
          )
      ],
    );
  }

  Widget _getEducationList() {
    return Row(
      children: [
        for (int iterator = 0;
            iterator < widget.resume.educationList.length;
            iterator++)
          EducationFormField(
            education: widget.resume.educationList[iterator],
            id: iterator,
            padding: EdgeInsets.only(left: iterator > 0 ? 10 : 0),
            onIconButtonPressed: () => iconImageSelectionPopup(
              iconData: widget.resume.educationList[iterator].iconData,
              imageURL: widget.resume.educationList[iterator].imageURL,
              showImage: widget.resume.educationList[iterator].showImage,
              onCheckmarkButtonPressed: (showImage) {
                widget.resume.educationList[iterator].showImage = showImage;
              },
              onUploadImageButtonPressed: () {},
              onSelectIconButtonPressed: () async {
                IconData? iconData = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackModes: [IconPack.cupertino]);
                if (iconData != null) {
                  widget.resume.educationList[iterator].iconData = iconData;
                }
              },
              onImageURLSubmitted: (value) async {
                bool successful = await widget.resume.educationList[iterator]
                    .loadImage(value.toString());
                // Handles snackbar async gap issue
                if (!mounted) return;

                if (!successful) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      Strings.failedToLoadNetworkImage,
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    backgroundColor: Colors.red[800],
                  ));
                }
              },
            ),
          )
      ],
    );
  }

  iconImageSelectionPopup({
    required IconData iconData,
    required String imageURL,
    required bool showImage,
    required Function()? onSelectIconButtonPressed,
    required Function(String?) onImageURLSubmitted,
    required Function(bool)? onCheckmarkButtonPressed,
    required Function()? onUploadImageButtonPressed,
  }) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => IconImageSelectionDialog(
              icon: iconData,
              imageURL: imageURL,
              onSelectIconButtonPressed: onSelectIconButtonPressed,
              onImageURLSubmitted: (url) {
                Navigator.of(context).pop();
                onImageURLSubmitted(url);
              },
              onCheckmarkButtonPressed: (showImage) {
                if (showImage && imageURL.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      Strings.addImageBeforeEnabling,
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    backgroundColor: Colors.orange[800],
                  ));
                } else {
                  onCheckmarkButtonPressed!(showImage);
                }
              },
              onUploadImageButtonPressed: onUploadImageButtonPressed,
              showImage: showImage,
            ));
  }
}
