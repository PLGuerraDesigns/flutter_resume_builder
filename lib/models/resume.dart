import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'contact.dart';
import 'education.dart';
import 'experience.dart';
import 'generic.dart';

/// The resume being edited.
class Resume extends ChangeNotifier {
  Resume({
    DateTime? creationDate,
    DateTime? lastModified,
    String? name,
    String? location,
    List<Contact>? contactList,
    List<Experience>? experiences,
    List<Education>? educationHistory,
    List<String>? skills,
    List<Map<String, GenericEntry>>? customSections,
    List<String>? sectionOrder,
    List<String>? hiddenSections,
    this.logoAsBytes,
  }) {
    this.creationDate = creationDate ?? DateTime.now();
    this.lastModified = lastModified ?? DateTime.now();
    nameController.text = name ?? '';
    locationController.text = location ?? '';
    this.contactList =
        contactList ?? <Contact>[Contact(), Contact(), Contact(), Contact()];
    this.experiences = experiences ?? <Experience>[Experience()];
    this.educationHistory = educationHistory ?? <Education>[Education()];
    skillTextControllers = skills != null
        ? skills.map((String e) => TextEditingController(text: e)).toList()
        : <TextEditingController>[TextEditingController()];
    this.customSections = customSections ?? <Map<String, GenericEntry>>[];
    this.sectionOrder = sectionOrder ??
        <String>[
          'Skills',
          'Experience',
          'Education',
        ];
    _hiddenSections = hiddenSections ?? <String>[];
  }

  factory Resume.fromMap(Map<String, dynamic> map) {
    return Resume(
      creationDate: DateTime.parse(map['creationDate'] as String),
      lastModified: DateTime.parse(map['lastModified'] as String),
      name: map['name'] as String,
      location: map['location'] as String,
      contactList: (map['contact'] as List<dynamic>)
          .map((dynamic e) => Contact.fromMap(e as Map<String, dynamic>))
          .toList(),
      experiences: (map['experience'] as List<dynamic>)
          .map((dynamic e) => Experience.fromMap(e as Map<String, dynamic>))
          .toList(),
      educationHistory: (map['education'] as List<dynamic>)
          .map((dynamic e) => Education.fromMap(e as Map<String, dynamic>))
          .toList(),
      skills: (map['skills'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      customSections: (map['customSections'] as List<dynamic>).map((dynamic e) {
        final Map<String, GenericEntry> customSection =
            <String, GenericEntry>{};
        for (final String key in (e as Map<String, dynamic>).keys) {
          for (final dynamic entry
              in (e[key] as List<dynamic>).cast<Map<String, dynamic>>()) {
            customSection[key] =
                GenericEntry.fromMap(entry as Map<String, dynamic>);
          }
        }
        return customSection;
      }).toList(),
      sectionOrder: (map['sectionOrder'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      logoAsBytes: map['logoAsBytes'] != null
          ? Uint8List.fromList(
              (map['logoAsBytes'] as List<dynamic>).cast<int>())
          : null,
    );
  }

  /// The creation date of the resume.
  DateTime creationDate = DateTime.now();

  /// The last modified date of the resume.
  DateTime lastModified = DateTime.now();

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

  /// The list of visible experiences.
  List<Experience> get visibleExperiences =>
      experiences.where((Experience e) => e.visible).toList();

  /// The educational history.
  List<Education> educationHistory = <Education>[];

  /// The list of visible education entries.
  List<Education> get visibleEducation =>
      educationHistory.where((Education e) => e.visible).toList();

  /// The list of skills.
  List<TextEditingController> skillTextControllers = <TextEditingController>[];

  /// The list of custom (user-defined) sections.
  List<Map<String, GenericEntry>> customSections =
      <Map<String, GenericEntry>>[];

  /// The list of visible custom sections.
  List<Map<String, GenericEntry>> get visibleCustomSections => customSections
      .where((Map<String, GenericEntry> e) => e.values.first.visible)
      .toList();

  /// The order of the sections.
  List<String> sectionOrder = <String>[];

  /// The logo as bytes.
  Uint8List? logoAsBytes;

  /// The list of hidden sections.
  List<String> _hiddenSections = <String>[];

  /// Whether the section is visible.
  bool sectionVisible(String sectionTitle) {
    return !_hiddenSections.contains(sectionTitle);
  }

  /// Add a new skill entry.
  void addSkill() {
    if (skillTextControllers
        .where((TextEditingController element) => element.text.isEmpty)
        .isNotEmpty) {
      return;
    }
    skillTextControllers.add(TextEditingController());
    notifyListeners();
  }

  /// Add a new professional experience entry.
  void addExperience() {
    experiences.insert(0, Experience());
    notifyListeners();
  }

  /// Add a new education entry.
  void addEducation() {
    educationHistory.insert(0, Education());
    notifyListeners();
  }

  /// Add a new custom section entry to the given section.
  void addCustomSectionEntry(String sectionTitle) {
    customSections.insert(
      0,
      <String, GenericEntry>{
        sectionTitle: GenericEntry(),
      },
    );
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
  void toggleSectionVisibility(String sectionTitle) {
    if (_hiddenSections.contains(sectionTitle)) {
      _hiddenSections.remove(sectionTitle);
    } else {
      _hiddenSections.add(sectionTitle);
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
  bool moveUpAllowed(String sectionTitle) {
    return sectionOrder.indexOf(sectionTitle) > 0;
  }

  /// Whether the section can be moved down.
  bool moveDownAllowed(String sectionTitle) {
    return sectionOrder.indexOf(sectionTitle) < sectionOrder.length - 1;
  }

  /// Whether the section can be removed. (Custom sections only)
  bool removeAllowed(String sectionTitle) {
    return customSections
        .where((Map<String, GenericEntry> element) =>
            element.containsKey(sectionTitle))
        .isNotEmpty;
  }

  /// Move the section up.
  void moveUp(String sectionTitle) {
    final int index = sectionOrder.indexOf(sectionTitle);
    if (index <= 0) {
      return;
    }
    sectionOrder.removeAt(index);
    sectionOrder.insert(index - 1, sectionTitle);
    notifyListeners();
  }

  /// Move the section down.
  void moveDown(String sectionTitle) {
    final int index = sectionOrder.indexOf(sectionTitle);
    if (index >= sectionOrder.length - 1) {
      return;
    }
    sectionOrder.removeAt(index);
    sectionOrder.insert(index + 1, sectionTitle);
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
  void onDeleteCustomSection(String sectionTitle) {
    sectionOrder.remove(sectionTitle);
    customSections.removeWhere((Map<String, GenericEntry> element) =>
        element.containsKey(sectionTitle));

    notifyListeners();
  }

  /// Delete a custom section entry.
  void onDeleteCustomSectionEntry(GenericEntry entry, String sectionTitle) {
    customSections
        .where((Map<String, GenericEntry> element) =>
            element.containsKey(sectionTitle))
        .first
        .removeWhere((String key, GenericEntry value) => value == entry);
    customSections.removeWhere(
        (Map<String, GenericEntry> element) => element.keys.isEmpty);
    if (customSections
        .where((Map<String, GenericEntry> element) =>
            element.containsKey(sectionTitle))
        .isEmpty) {
      addCustomSectionEntry(sectionTitle);
    }

    notifyListeners();
  }

  /// Delete a contact.
  void onDeleteExperience(Experience experience) {
    experiences.remove(experience);
    if (experiences.isEmpty) {
      addExperience();
    }
    notifyListeners();
  }

  /// Delete an education entry.
  void onDeleteEducation(Education education) {
    educationHistory.remove(education);
    if (educationHistory.isEmpty) {
      addEducation();
    }
    notifyListeners();
  }

  /// Rebuild the resume/UI.
  void rebuild() {
    notifyListeners();
  }

  /// Return a map of the resume.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'creationDate': creationDate.toString(),
      'lastModified': lastModified.toString(),
      'name': nameController.text,
      'location': locationController.text,
      'contact': contactList.map((Contact e) => e.toMap()).toList(),
      'experience': experiences.map((Experience e) => e.toMap()).toList(),
      'education': educationHistory.map((Education e) => e.toMap()).toList(),
      'skills': skillTextControllers
          .map((TextEditingController e) => e.text)
          .toList(),
      'customSections': customSections
          .map((Map<String, GenericEntry> entry) =>
              <String, List<Map<String, dynamic>>>{
                entry.keys.first: <Map<String, dynamic>>[
                  for (final GenericEntry entry in entry.values) entry.toMap()
                ],
              })
          .toList(),
      'sectionOrder': sectionOrder,
      'hiddenSections': _hiddenSections,
      'logoAsBytes': logoAsBytes
    };
    return map;
  }
}
