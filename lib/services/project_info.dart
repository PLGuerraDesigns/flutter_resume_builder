import 'package:package_info_plus/package_info_plus.dart';

/// Contains information about the project version.
class ProjectVersionInfoHandler {
  ProjectVersionInfoHandler() {
    _init();
  }

  /// The package info instance.
  late PackageInfo packageInfo;

  /// Initializes the package info.
  Future<void> _init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  /// The project version number.
  String get version => packageInfo.version;

  /// The project build number.
  String get buildNumber => packageInfo.buildNumber;
}
