import 'package:flutter/foundation.dart';

/// Одна лицензия в разделе «Настройки → Лицензии»: пакет(ы) и полный текст.
class SettingsLicense {
  const SettingsLicense({required this.packages, required this.text});

  /// Имена пакетов лицензии через «, » (у одного entry их может быть несколько).
  final String packages;

  /// Текст лицензии (абзацы объединены пустой строкой).
  final String text;
}

/// Читает все лицензии, зарегистрированные во Flutter (зависимости pub
/// попадают сюда автоматически, свои — через LicenseRegistry.addLicense).
Future<List<SettingsLicense>> loadSettingsLicenses() async {
  final licenses = <SettingsLicense>[];
  await for (final entry in LicenseRegistry.licenses) {
    final packages = entry.packages.join(', ');
    final text = entry.paragraphs.map((paragraph) => paragraph.text).join('\n\n').trim();
    if (packages.isEmpty || text.isEmpty) continue;
    licenses.add(SettingsLicense(packages: packages, text: text));
  }
  licenses.sort((a, b) => a.packages.toLowerCase().compareTo(b.packages.toLowerCase()));
  return licenses;
}
