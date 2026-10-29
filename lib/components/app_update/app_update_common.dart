import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../desktop.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../platform.dart';
import '../../settings.dart';
import '../../utils.dart';

/// Сборка [current] старше [minimal] (версии «0.0.570», сравнение по числам;
/// пустая или негодная [minimal] — нет).
bool isVersionOlder(String current, String minimal) {
  List<int>? parse(String version) {
    final parts = version.trim().split('.');
    final numbers = [for (final part in parts) int.tryParse(part)];
    if (version.trim().isEmpty || numbers.contains(null)) return null;
    return numbers.cast<int>();
  }

  final a = parse(current), b = parse(minimal);
  if (a == null || b == null) return false;
  for (var i = 0; i < 3; i++) {
    final x = i < a.length ? a[i] : 0, y = i < b.length ? b[i] : 0;
    if (x != y) return x < y;
  }
  return false;
}

/// Открыть обновление: Google Play, TestFlight (пока нет страницы в App
/// Store), на macOS — проверка Sparkle.
Future<void> openAppUpdate() async {
  if (AppPlatform.isDesktop) return Desktop.checkForUpdates();
  final uri = Platform.isIOS ? Uri.parse('itms-beta://') : Uri.parse('https://play.google.com/store/apps/details?id=net.iperon.messenger');
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace, 'app update: open store');
  }
}

/// Слой «Обновите приложение» поверх всего приложения: версия сборки старше
/// минимальной из админки (`client.minimalVersion`, [Settings.minimalVersion]).
/// Следит за [Settings] — минимальную версию поднимают без перезапуска.
class AppUpdateGate extends StatefulWidget {
  final Widget Function(BuildContext context, String current, String minimal) builder;

  const AppUpdateGate({super.key, required this.builder});

  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends State<AppUpdateGate> {
  final _settings = getIt.get<Settings>();
  String? _version;

  @override
  void initState() {
    super.initState();
    getIt.get<Utils>().packageInfo().then((info) {
      if (mounted) setState(() => _version = info.appVersion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final version = _version;
        if (version == null || !isVersionOlder(version, _settings.minimalVersion)) return const SizedBox.shrink();
        return Positioned.fill(child: widget.builder(context, version, _settings.minimalVersion));
      },
    );
  }
}
