import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_resume_builder/models/contact.dart';
import 'package:flutter_resume_builder/models/education.dart';
import 'package:flutter_resume_builder/models/experience.dart';

class Resume extends ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();

  late String _name;

  late String _location;

  late String _summary;

  late List<Contact> _contactList = [];

  late List<Experience> _experienceList = [];

  late List<Education> _educationList = [];

  late List<String> _skillList = [];

  bool _showRecompileButton = true;

  Resume() {
    name = '';
    location = '';
    summary = '';
    _contactList = [Contact(), Contact()];
    _experienceList = [Experience()];
    _educationList = [Education(), Education()];
  }

  String get name => _name;

  bool get showRecompileButton => _showRecompileButton;

  String get location => _location;

  String get summary => _summary;

  UnmodifiableListView<Experience> get experienceList =>
      UnmodifiableListView(_experienceList);

  UnmodifiableListView<Education> get educationList =>
      UnmodifiableListView(_educationList);

  UnmodifiableListView<Contact> get contactList =>
      UnmodifiableListView(_contactList);

  UnmodifiableListView<String> get skillList =>
      UnmodifiableListView(_skillList);

  set contactList(List<Contact> contactList) {
    _contactList = contactList;
    attachContactInfoListListeners();
  }

  set experienceList(List<Experience> experienceList) {
    _experienceList = experienceList;
    attachExperienceListListeners();
  }

  set educationList(List<Education> educationList) {
    _educationList = educationList;
    attachEducationListListeners();
  }

  set skillList(List<String> skillList) {
    _skillList = skillList;
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set summary(String summary) {
    _summary = summary;
    notifyListeners();
  }

  set showRecompileButton(bool value) {
    _showRecompileButton = value;
    notifyListeners();
  }

  set location(String location) {
    _location = location;
    notifyListeners();
  }

  void addContact() {
    if (_contactList.length < 4) {
      _contactList.add(Contact());
      notifyListeners();
    }
  }

  void addExperience() {
    if (_experienceList.length < 4) {
      _experienceList.add(Experience());
      notifyListeners();
    }
  }

  void addEducation() {
    if (_educationList.length < 4) {
      _educationList.add(Education());
      notifyListeners();
    }
  }

  void attachContactInfoListListeners() {
    for (var element in contactList) {
      if (!element.hasListeners) {
        element.addListener(() {
          notifyListeners();
        });
      }
    }
  }

  void attachExperienceListListeners() {
    for (var element in experienceList) {
      if (!element.hasListeners) {
        element.addListener(() {
          notifyListeners();
        });
      }
    }
  }

  void attachEducationListListeners() {
    for (var element in educationList) {
      if (!element.hasListeners) {
        element.addListener(() {
          notifyListeners();
        });
      }
    }
  }
}
