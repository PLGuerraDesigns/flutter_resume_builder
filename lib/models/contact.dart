import 'package:flutter/cupertino.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

class Contact extends ChangeNotifier {
  late String _details;

  late IconData _iconData;

  late pdf.ImageProvider _imageProvider;

  late String _imageURL;

  late bool _showImage;

  String get details => _details;

  IconData get iconData => _iconData;

  String get imageURL => _imageURL;

  bool get showImage => _showImage;

  pdf.ImageProvider get imageProvider => _imageProvider;

  set showImage(bool showImage) {
    _showImage = showImage;
    notifyListeners();
  }

  set details(String details) {
    _details = details;
    notifyListeners();
  }

  set iconData(IconData icon) {
    _iconData = icon;
    _showImage = false;
    notifyListeners();
  }

  Future<bool> loadImage(String url) async {
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

  Contact({String? details, IconData? icon, String? imageURL}) {
    this.details = details ??= "";
    iconData = icon ??= CupertinoIcons.phone;
    _showImage = false;
    loadImage(imageURL ??= '');
  }
}
