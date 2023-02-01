import 'package:flutter/cupertino.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdf;

class Education extends ChangeNotifier {
  late IconData _iconData;

  late String _institution;

  late String _degree;

  late DateTime _startDate;

  late DateTime _endDate;

  late String _imageURL;

  late pdf.ImageProvider _imageProvider;

  late bool _showImage;

  String get institution => _institution;

  String get degree => _degree;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  IconData get iconData => _iconData;

  String get imageURL => _imageURL;

  bool get showImage => _showImage;

  pdf.ImageProvider get imageProvider => _imageProvider;

  set showImage(bool showImage) {
    _showImage = showImage;
    notifyListeners();
  }

  set institution(String institution) {
    _institution = institution;
    notifyListeners();
  }

  set degree(String degree) {
    _degree = degree;
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

  Education({institution, degree, startDate, endDate, icon, imageURL}) {
    this.institution = institution ??= "";
    this.degree = degree ??= "";
    this.startDate =
        startDate ??= DateTime.now().subtract(const Duration(days: 365 * 4));
    this.endDate = endDate ??= DateTime.now();
    iconData = icon ??= CupertinoIcons.book;
    _showImage = false;
    loadImage(imageURL ??= '');
  }
}
