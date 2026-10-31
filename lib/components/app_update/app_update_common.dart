import 'dart:io';

import 'package:flutter/services.dart';
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

/// Откуда установлено приложение — обновляем через тот же канал
/// (docs/plans/app-updates.md §3).
enum AppInstallChannel { googlePlay, ruStore, apk, testFlight, appStore, desktop }

/// Канал установки и ABI устройства (для ссылки на APK).
class AppInstallSource {
  final AppInstallChannel channel;

  /// Build.SUPPORTED_ABIS (Android), по предпочтению; иначе пусто.
  final List<String> abis;

  const AppInstallSource(this.channel, [this.abis = const []]);
}

/// Откуда раздаются сборки (nginx, файлы из GitHub Releases; сервер —
/// iperon docs/nginx/download.iperon.net.conf).
const appDownloadHost = 'https://download.iperon.net';

/// ABI, под которые CI собирает APK (`--split-per-abi`).
const _apkAbis = ['arm64-v8a', 'armeabi-v7a', 'x86_64'];

const _channel = MethodChannel('net.iperon.messenger/app_update');
Future<AppInstallSource>? _installSource;

/// Канал установки: Android — по установщику (AppInstallSource.kt), iOS — по
/// чеку (AppUpdateBridge в AppDelegate.swift). Не меняется, пока процесс жив, —
/// считаем один раз. Ошибка натива — Android считаем APK, iOS — TestFlight.
Future<AppInstallSource> appInstallSource() => _installSource ??= _detectInstallSource();

Future<AppInstallSource> _detectInstallSource() async {
  if (AppPlatform.isDesktop) return const AppInstallSource(AppInstallChannel.desktop);
  try {
    final info = await _channel.invokeMapMethod<String, Object?>('installSource');
    if (Platform.isIOS) {
      return AppInstallSource(info?['testFlight'] == false ? AppInstallChannel.appStore : AppInstallChannel.testFlight);
    }
    final abis = [for (final abi in (info?['abis'] as List?) ?? const []) '$abi'];
    final channel = switch (info?['installer']) {
      'com.android.vending' => AppInstallChannel.googlePlay,
      'ru.vk.store' => AppInstallChannel.ruStore,
      _ => AppInstallChannel.apk,
    };
    return AppInstallSource(channel, abis);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace, 'app update: install source');
    return AppInstallSource(Platform.isIOS ? AppInstallChannel.testFlight : AppInstallChannel.apk);
  }
}

/// Ссылка на APK последней версии под ABI устройства (первый из
/// Build.SUPPORTED_ABIS, под который есть сборка; иначе arm64-v8a).
Uri apkDownloadUri(List<String> abis) {
  final abi = abis.firstWhere(_apkAbis.contains, orElse: () => _apkAbis.first);
  return Uri.parse('$appDownloadHost/android/Iperon-$abi.apk');
}

/// Открыть обновление в канале установки: Google Play, RuStore, APK с сайта
/// (браузер скачает, установка — системным окном), TestFlight (страницы в App
/// Store пока нет — App Store тоже туда), на macOS — проверка Sparkle.
Future<void> openAppUpdate() async {
  final source = await appInstallSource();
  final uri = switch (source.channel) {
    AppInstallChannel.desktop => null,
    AppInstallChannel.googlePlay => Uri.parse('https://play.google.com/store/apps/details?id=net.iperon.messenger'),
    AppInstallChannel.ruStore => Uri.parse('https://www.rustore.ru/catalog/app/net.iperon.messenger'),
    AppInstallChannel.apk => apkDownloadUri(source.abis),
    AppInstallChannel.testFlight || AppInstallChannel.appStore => Uri.parse('itms-beta://'),
  };
  if (uri == null) return Desktop.checkForUpdates();
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace, 'app update: open ${source.channel.name}');
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
