import 'package:package_info_plus/package_info_plus.dart';

import '../common/strings.dart';

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

  /// The project name.
  String get appName => packageInfo.appName;

  /// The project site URL.
  String get siteUrl => Strings.siteUrl;

  /// The project version number.
  String get version => packageInfo.version;

  /// The project build number.
  String get buildNumber => packageInfo.buildNumber;

  String get fullVersion => '$version ($buildNumber)';

  /// Return a map of the project version info.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appName': appName,
      'siteUrl': siteUrl,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}
