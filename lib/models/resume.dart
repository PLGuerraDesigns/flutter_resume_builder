import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../constants/strings.dart';
import 'contact.dart';
import 'education.dart';
import 'experience.dart';
import 'generic.dart';

/// The resume being edited.
class Resume extends ChangeNotifier {
  Resume() {
    nameController.text = '';
    locationController.text = '';
    contactList = <Contact>[Contact(), Contact(), Contact(), Contact()];
    experiences = <Experience>[
      Experience(),
      Experience(),
    ];
    educationHistory = <Education>[
      Education(),
      Education(),
    ];
    customSections = <Map<String, GenericEntry>>[
      <String, GenericEntry>{
        'Projects': GenericEntry(),
      },
    ];
    sectionOrder = <String>[
      Strings.skills,
      Strings.experience,
      'Projects',
      Strings.education,
    ];
  }

  /// The form key for the resume.
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// The controller for the name field.
  TextEditingController nameController = TextEditingController();

  /// The controller for the location field.
  TextEditingController locationController = TextEditingController();

  /// The list of contacts.
  List<Contact> contactList = <Contact>[];

  /// The list of professional experiences.
  List<Experience> experiences = <Experience>[];

  /// The educational history.
  List<Education> educationHistory = <Education>[];

  /// The list of skills.
  List<TextEditingController> skillTextControllers = <TextEditingController>[];

  /// The list of custom (user-defined) sections.
  List<Map<String, GenericEntry>> customSections =
      <Map<String, GenericEntry>>[];

  /// The order of the sections.
  List<String> sectionOrder = <String>[];

  /// The logo as bytes.
  Uint8List? logoAsBytes;

  /// The list of hidden sections.
  final List<String> _hiddenSections = <String>[];

  /// Whether the section is visible.
  bool sectionVisible(String sectionName) {
    return !_hiddenSections.contains(sectionName);
  }

  /// Add a new professional experience entry.
  void addExperience() {
    experiences.add(Experience());
    notifyListeners();
  }

  /// Add a new education entry.
  void addEducation() {
    educationHistory.add(Education());
    notifyListeners();
  }

  /// Create a new custom section.
  void addCustomSection() {
    customSections.add(<String, GenericEntry>{
      'Title ${customSections.length + 1}': GenericEntry(),
    });
    sectionOrder.add('Title ${customSections.length}');
    notifyListeners();
  }

  /// Toggle the visibility of a section.
  void toggleSectionVisibility(String sectionName) {
    if (_hiddenSections.contains(sectionName)) {
      _hiddenSections.remove(sectionName);
    } else {
      _hiddenSections.add(sectionName);
    }
    notifyListeners();
  }

  /// Rename a custom section.
  void renameCustomSection(String oldName, String newName) {
    final int index = sectionOrder.indexOf(oldName);
    sectionOrder.removeAt(index);
    sectionOrder.insert(index, newName);
    for (final Map<String, GenericEntry> element in customSections) {
      if (element.containsKey(oldName)) {
        final Map<String, GenericEntry> newMap = <String, GenericEntry>{
          newName: element[oldName]!
        };
        element.remove(oldName);
        element.addAll(newMap);
      }
    }
    notifyListeners();
  }

  /// Add a logo to the resume.
  void addLogo(Uint8List logoAsBytes) {
    this.logoAsBytes = logoAsBytes;
    notifyListeners();
  }

  /// Whether the section can be moved up.
  bool moveUpAllowed(String sectionName) {
    return sectionOrder.indexOf(sectionName) > 0;
  }

  /// Whether the section can be moved down.
  bool moveDownAllowed(String sectionName) {
    return sectionOrder.indexOf(sectionName) < sectionOrder.length - 1;
  }

  /// Whether the section can be removed. (Custom sections only)
  bool removeAllowed(String sectionName) {
    return customSections
        .where((Map<String, GenericEntry> element) =>
            element.containsKey(sectionName))
        .isNotEmpty;
  }

  /// Move the section up.
  void moveUp(String sectionName) {
    final int index = sectionOrder.indexOf(sectionName);
    if (index <= 0) {
      return;
    }
    sectionOrder.removeAt(index);
    sectionOrder.insert(index - 1, sectionName);
    notifyListeners();
  }

  /// Move the section down.
  void moveDown(String sectionName) {
    final int index = sectionOrder.indexOf(sectionName);
    if (index >= sectionOrder.length - 1) {
      return;
    }
    sectionOrder.removeAt(index);
    sectionOrder.insert(index + 1, sectionName);
    notifyListeners();
  }

  /// Rearrange the contact info list.
  void onReorderContactInfoList(int oldIndex, int newIndex) {
    final Contact item = contactList.removeAt(oldIndex);
    contactList.insert(newIndex, item);
    notifyListeners();
  }

  /// Rearrange the skills list.
  void onReorderSkillsList(int oldIndex, int newIndex) {
    final String item = skillTextControllers.removeAt(oldIndex).text;
    skillTextControllers.insert(newIndex, TextEditingController(text: item));
    notifyListeners();
  }

  /// Rearrange the experience list.
  void onReorderExperienceList(int oldIndex, int newIndex) {
    newIndex = newIndex - 1;
    if (newIndex < 0) {
      newIndex = 0;
    }
    final Experience item = experiences.removeAt(oldIndex);
    experiences.insert(newIndex, item);
    notifyListeners();
  }

  /// Rearrange the education list.
  void onReorderEducationList(int oldIndex, int newIndex) {
    newIndex = newIndex - 1;
    if (newIndex < 0) {
      newIndex = 0;
    }
    final Education item = educationHistory.removeAt(oldIndex);
    educationHistory.insert(newIndex, item);
    notifyListeners();
  }

  /// Rearrange a custom section list.
  void onReorderCustomSectionList(int oldIndex, int newIndex) {
    final Map<String, GenericEntry> item = customSections.removeAt(oldIndex);
    customSections.insert(newIndex, item);
    notifyListeners();
  }

  /// Delete a custom section.
  void onDeleteCustomSection(String sectionName) {
    sectionOrder.remove(sectionName);
    customSections.removeWhere((Map<String, GenericEntry> element) =>
        element.containsKey(sectionName));

    notifyListeners();
  }

  /// Rebuild the resume/UI.
  void rebuild() {
    notifyListeners();
  }
}
