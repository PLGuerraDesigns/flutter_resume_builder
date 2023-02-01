import 'package:flutter/cupertino.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

class Experience extends ChangeNotifier {
  late String _company;

  late String _position;

  late String _description;

  late DateTime _startDate;

  late DateTime _endDate;

  late IconData _iconData;

  late String _imageURL;

  late pdf.ImageProvider _imageProvider;

  late bool _showImage;

  String get company => _company;

  String get position => _position;

  String get description => _description;

  String get imageURL => _imageURL;

  bool get showImage => _showImage;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  IconData get iconData => _iconData;

  pdf.ImageProvider get imageProvider => _imageProvider;

  set showImage(bool showImage) {
    _showImage = showImage;
    notifyListeners();
  }

  set company(String company) {
    _company = company;
    notifyListeners();
  }

  set position(String position) {
    _position = position;
    notifyListeners();
  }

  set description(String description) {
    _description = description;
    notifyListeners();
  }

  set startDate(DateTime dateTime) {
    _startDate = dateTime;
    notifyListeners();
  }

  set endDate(DateTime dateTime) {
    _endDate = dateTime;
    notifyListeners();
  }

  set iconData(IconData icon) {
    _iconData = icon;
    _showImage = false;
    notifyListeners();
  }

  loadImage(String url) async {
    _imageURL = url;
    try {
      _imageProvider = await networkImage(url);
      _showImage = true;
      notifyListeners();
      return true;
    } catch (error) {
      _imageURL = '';
      _showImage = false;
      notifyListeners();
      return false;
    }
  }

  Experience(
      {company, position, description, startDate, endDate, icon, imageURL}) {
    this.company = company ??= '';
    this.position = position ??= '';
    this.description = description ??= '';
    this.startDate =
        startDate ??= DateTime.now().subtract(const Duration(days: 180));
    this.endDate = endDate ??= DateTime.now();
    iconData = icon ??= CupertinoIcons.building_2_fill;
    _showImage = false;
    loadImage(imageURL ??= '');
  }
}
