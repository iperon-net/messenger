import 'dart:io';

import 'package:flutter/services.dart';

import '../../di.dart';
import '../../utils.dart';

/// Версии для экрана «О приложении»: приложение (как в CI: `0.0.597 (59701)`),
/// Flutter и Dart, на которых оно собрано.
class SettingsAboutVersions {
  final String app;
  final String flutter;
  final String dart;

  const SettingsAboutVersions({required this.app, required this.flutter, required this.dart});
}

Future<SettingsAboutVersions> loadSettingsAboutVersions() async {
  final info = await getIt.get<Utils>().packageInfo();
  return SettingsAboutVersions(
    app: '${info.appVersion} (${info.appBuildNumber})',
    // flutter tool передаёт их в сборку (--dart-define FLUTTER_VERSION и т. п.);
    // Dart без них — из рантайма («3.10.0 (stable) …» → «3.10.0»).
    flutter: FlutterVersion.version ?? '—',
    dart: FlutterVersion.dartVersion ?? Platform.version.split(' ').first,
  );
}
