import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../constants/strings.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/generic.dart';
import '../models/resume.dart';
import '../widgets/contact_entry.dart';
import '../widgets/custom_entry.dart';
import '../widgets/education_entry.dart';
import '../widgets/experience_entry.dart';
import '../widgets/frosted_container.dart';
import '../widgets/generic_text_field.dart';
import '../widgets/image_file_picker.dart';

/// The input form for the resume.
class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  /// The key for the contact section.
  final GlobalKey<State<StatefulWidget>> _contactSectionKey = GlobalKey();

  /// The key for the skill section.
  final GlobalKey<State<StatefulWidget>> _skillSectionKey = GlobalKey();

  /// Form fields for requesting the user's name, location, and a logo.
  Widget _header(Resume resume) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                GenericTextField(
                  label: Strings.name,
                  roundedStyling: false,
                  controller: resume.nameController,
                  onSubmitted: (_) => resume.rebuild(),
                ),
                const SizedBox(height: 10),
                GenericTextField(
                  label: Strings.location,
                  roundedStyling: false,
                  controller: resume.locationController,
                  onSubmitted: (_) => resume.rebuild(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ImageFilePicker(
            logoFileBytes: resume.logoAsBytes,
            onPressed: () async {
              final FilePickerResult? result =
                  await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: <String>['jpg', 'png', 'jpeg'],
              );
              if (result != null) {
                resume.logoAsBytes = result.files.first.bytes;
                resume.rebuild();
              }
            },
          ),
        ),
      ],
    );
  }

  /// A section title with buttons for adding, removing, hiding, and reordering
  /// the section.
  Widget _sectionTitle({
    required String title,
    required Resume resume,
    required Function()? onAddPressed,
    bool allowVisibilityToggle = false,
    bool reOrderable = true,
    bool titleEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          if (titleEditable)
            Expanded(
              child: GenericTextField(
                key: UniqueKey(),
                label: '',
                controller: TextEditingController(text: title),
                roundedStyling: false,
                onSubmitted: (String? value) {
                  resume.renameCustomSection(title, value.toString());
                },
              ),
            ),
          if (!titleEditable)
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          const Expanded(
            flex: 2,
            child: Divider(
              indent: 10,
              endIndent: 10,
              color: Colors.white,
            ),
          ),
          if (resume.removeAllowed(title))
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      deleteSectionConfirmationDialog(
                    context: context,
                    resume: resume,
                    sectionName: title,
                  ),
                );
              },
              tooltip: Strings.removeSection,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: const Icon(Icons.delete_outline),
            ),
          if (allowVisibilityToggle)
            IconButton(
              onPressed: () => resume.toggleSectionVisibility(title),
              tooltip: resume.sectionVisible(title)
                  ? Strings.hideAllEntries
                  : Strings.showAllEntries,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: Icon(
                resume.sectionVisible(title)
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
          if (onAddPressed != null)
            IconButton(
              onPressed: onAddPressed,
              tooltip: Strings.newEntry,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: const Icon(Icons.add),
            ),
          if (reOrderable)
            IconButton(
              onPressed: resume.moveUpAllowed(title)
                  ? () => resume.moveUp(title)
                  : null,
              tooltip: Strings.moveSectionUp,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: const Icon(Icons.expand_less_outlined),
            ),
          if (reOrderable)
            IconButton(
              onPressed: resume.moveDownAllowed(title)
                  ? () => resume.moveDown(title)
                  : null,
              tooltip: Strings.moveSectionDown,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: const Icon(Icons.expand_more_outlined),
            ),
        ],
      ),
    );
  }

  /// A grid of contact fields.
  Widget _contactSection(Resume resume) {
    return ReorderableBuilder(
        longPressDelay: const Duration(milliseconds: 250),
        key: _contactSectionKey,
        builder: (List<Widget> children) {
          return GridView.custom(
            key: _contactSectionKey,
            shrinkWrap: true,
            childrenDelegate: SliverChildListDelegate(children),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 74,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          );
        },
        children: List<Widget>.generate(
          resume.contactList.length,
          (int index) => ContactEntry(
            key: UniqueKey(),
            contact: resume.contactList[index],
            onTextSubmitted: (String? value) {
              resume.rebuild();
            },
            onIconButtonPressed: () async {
              final IconData? iconData = await FlutterIconPicker.showIconPicker(
                  context,
                  iconPackModes: <IconPack>[IconPack.cupertino]);
              if (iconData != null) {
                resume.contactList[index].iconData = iconData;
              }
              resume.rebuild();
            },
          ),
        ),
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final OrderUpdateEntity element in orderUpdateEntities) {
            resume.onReorderContactInfoList(element.oldIndex, element.newIndex);
          }
        });
  }

  /// A grid of skill fields.
  Widget _skillsSection(Resume resume) {
    return Column(
      children: <Widget>[
        _sectionTitle(
          title: Strings.skills,
          resume: resume,
          allowVisibilityToggle: true,
          onAddPressed: () {
            setState(() {
              resume.skillTextControllers.add(TextEditingController());
            });
          },
        ),
        Opacity(
          opacity: resume.sectionVisible(Strings.skills) ? 1 : 0.5,
          child: ReorderableBuilder(
            longPressDelay: const Duration(milliseconds: 250),
            key: _skillSectionKey,
            enableScrollingWhileDragging: false,
            onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
              for (final OrderUpdateEntity element in orderUpdateEntities) {
                resume.onReorderSkillsList(element.oldIndex, element.newIndex);
              }
            },
            builder: (List<Widget> children) {
              return GridView.custom(
                physics: const NeverScrollableScrollPhysics(),
                key: _skillSectionKey,
                shrinkWrap: true,
                childrenDelegate: SliverChildListDelegate(children),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 74,
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              );
            },
            children: List<Widget>.generate(
              resume.skillTextControllers.length,
              (int index) => FrostedContainer(
                key: UniqueKey(),
                child: TextFormField(
                  controller: resume.skillTextControllers[index],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onFieldSubmitted: (String value) {
                    resume.rebuild();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// A list of experience fields.
  Widget _experienceSection(Resume resume) {
    return Column(
      children: <Widget>[
        _sectionTitle(
          title: Strings.experience,
          resume: resume,
          onAddPressed: () {
            setState(() {
              resume.experiences.add(Experience());
            });
          },
        ),
        ReorderableList(
          itemCount: resume.experiences.length,
          shrinkWrap: true,
          proxyDecorator: _proxyDecorator,
          onReorder: (int oldIndex, int newIndex) {
            resume.onReorderExperienceList(oldIndex, newIndex);
          },
          itemBuilder: (BuildContext context, int index) {
            return ReorderableDragStartListener(
              key: Key('${Strings.experience}$index'),
              index: index,
              child: ExperienceEntry(
                experience: resume.experiences[index],
                onSubmitted: (_) {
                  resume.rebuild();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// A list of education fields.
  Widget _educationSection(Resume resume) {
    return Column(
      children: <Widget>[
        _sectionTitle(
          title: Strings.education,
          resume: resume,
          onAddPressed: () {
            setState(() {
              resume.educationHistory.add(Education());
            });
          },
        ),
        ReorderableList(
          itemCount: resume.educationHistory.length,
          shrinkWrap: true,
          proxyDecorator: _proxyDecorator,
          onReorder: (int oldIndex, int newIndex) {
            resume.onReorderEducationList(oldIndex, newIndex);
          },
          itemBuilder: (BuildContext context, int index) {
            return ReorderableDragStartListener(
              key: Key('${Strings.education}$index'),
              index: index,
              child: EducationEntry(
                education: resume.educationHistory[index],
                onSubmitted: (_) {
                  resume.rebuild();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// A list of custom fields.
  Widget _customSection({required String title, required Resume resume}) {
    final List<GenericEntry> genericSection = <GenericEntry>[];
    for (final Map<String, GenericEntry> section in resume.customSections) {
      if (section.containsKey(title)) {
        genericSection.add(section[title]!);
      }
    }

    return Column(
      children: <Widget>[
        _sectionTitle(
          title: title,
          resume: resume,
          titleEditable: true,
          allowVisibilityToggle: true,
          onAddPressed: () {
            setState(() {
              resume.customSections.add(
                <String, GenericEntry>{
                  title: GenericEntry(),
                },
              );
            });
          },
        ),
        Opacity(
          opacity: resume.sectionVisible(title) ? 1 : 0.5,
          child: ReorderableList(
            itemCount: genericSection.length,
            shrinkWrap: true,
            proxyDecorator: _proxyDecorator,
            onReorder: (int oldIndex, int newIndex) {
              resume.onReorderCustomSectionList(oldIndex, newIndex);
            },
            itemBuilder: (BuildContext context, int index) {
              return ReorderableDragStartListener(
                key: Key('$title$index'),
                index: index,
                child: CustomEntry(
                  genericSection: genericSection[index],
                  onSubmitted: (_) {
                    resume.rebuild();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Adds a shadow to the widget being reordered in a list.
  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Transform.rotate(
          angle: lerpDouble(0, -0.025, animValue)!,
          child: Material(
            elevation: elevation,
            color: Colors.transparent,
            shadowColor: Colors.black54,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// A confirmation dialog for deleting a custom section.
  Widget deleteSectionConfirmationDialog(
      {required BuildContext context,
      required Resume resume,
      required String sectionName}) {
    return AlertDialog(
      title: Text(Strings.deleteSection(sectionName)),
      content: const Text(
        Strings.deleteSectionWarning,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            resume.onDeleteCustomSection(sectionName);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text(
            Strings.delete,
          ),
        ),
      ],
    );
  }

  /// Returns a list of sections in the order they should be displayed.
  List<Widget> _orderedSections(Resume resume) {
    final List<Widget> sections = <Widget>[];
    for (final String sectionTitle in resume.sectionOrder) {
      switch (sectionTitle) {
        case Strings.skills:
          sections.add(_skillsSection(resume));
          break;
        case Strings.experience:
          sections.add(_experienceSection(resume));
          break;
        case Strings.education:
          sections.add(_educationSection(resume));
          break;
        default:
          sections.add(_customSection(title: sectionTitle, resume: resume));
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Resume>(
        builder: (BuildContext context, Resume resume, Widget? child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
              key: resume.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _header(resume),
                  const SizedBox(height: 10),
                  _contactSection(resume),
                  ..._orderedSections(resume),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: resume.addCustomSection,
                    child: Text(
                      Strings.addNewSection.toUpperCase(),
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
