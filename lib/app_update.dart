import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/app_update/app_update_common.dart';
import 'di.dart';
import 'logger.dart';
import 'repositories/repositories.dart';
import 'utils.dart';

/// Доступная новая версия — баннер «Доступна версия» над списком чатов.
class AppUpdateOffer {
  final String version;
  final int build;

  /// Куда ведёт «Обновить»: APK под ABI устройства.
  final Uri uri;

  const AppUpdateOffer({required this.version, required this.build, required this.uri});
}

/// Мягкое уведомление о новой версии (этап 2 docs/plans/app-updates.md).
/// Пока только канал APK: манифест `latest.json` последнего релиза (его кладёт
/// CI, `_deploy_android.yaml`; раздаёт nginx download.iperon.net). Магазины —
/// своими API (этапы 4–5), macOS — Sparkle, iOS (TestFlight сам сообщает о
/// сборках) — без баннера. Проверка — при старте, при появлении сети и раз в
/// [_interval], пока приложение на экране; без сети — молча пропускается.
class AppUpdates {
  AppUpdates._();

  static final instance = AppUpdates._();

  static const _interval = Duration(hours: 6);

  /// «Позже» прячет баннер этой версии на столько.
  static const snooze = Duration(hours: 24);

  static final manifestUri = Uri.parse('$appDownloadHost/android/latest.json');

  /// null — обновления нет (или его отложили).
  final available = ValueNotifier<AppUpdateOffer?>(null);

  bool _started = false;
  bool _checking = false;
  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;

  /// Запуск проверок; повторный вызов (смена аккаунта) ничего не делает.
  void start() {
    // debug-сборка — номер 0: баннер был бы всегда.
    if (_started || kDebugMode) return;
    _started = true;
    unawaited(check());
    _timer = Timer.periodic(_interval, (_) => check());
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) unawaited(check());
    });
  }

  Future<void> check() async {
    if (_checking) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    _checking = true;
    try {
      final source = await appInstallSource();
      if (source.channel != AppInstallChannel.apk) return;
      final current = int.tryParse((await getIt.get<Utils>().packageInfo()).appBuildNumber) ?? 0;
      final manifest = await _fetchManifest();
      if (manifest == null) return;
      final dismissed = await getIt.get<DeviceRepositories>().settingsDevice.updateDismissed();
      available.value = offerFrom(
        manifest,
        currentBuild: current,
        abis: source.abis,
        dismissedBuild: dismissed.build,
        dismissedAt: DateTime.fromMillisecondsSinceEpoch(dismissed.at),
        now: DateTime.now(),
      );
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'app update: check');
    } finally {
      _checking = false;
    }
  }

  /// «Позже»: баннер этой версии — не раньше чем через [snooze].
  Future<void> dismiss() async {
    final offer = available.value;
    if (offer == null) return;
    available.value = null;
    await getIt.get<DeviceRepositories>().settingsDevice.setUpdateDismissed(build: offer.build, at: DateTime.now().millisecondsSinceEpoch);
  }

  /// «Обновить» в баннере: APK в браузере, установка — системным окном (своя
  /// загрузка с установкой — этап 3).
  Future<void> open() async {
    final offer = available.value;
    if (offer == null) return;
    try {
      await launchUrl(offer.uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'app update: open apk');
    }
  }

  /// Манифест; null — нет сети / сервер не ответил (не ошибка, повторим позже).
  Future<Map<String, Object?>?> _fetchManifest() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final response = await (await client.getUrl(manifestUri)).close().timeout(const Duration(seconds: 15));
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<void>();
        return null;
      }
      final body = await response.transform(utf8.decoder).join().timeout(const Duration(seconds: 15));
      return jsonDecode(body) as Map<String, Object?>;
    } on SocketException {
      return null;
    } on TimeoutException {
      return null;
    } on HttpException {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  /// Что показать по манифесту: сборка новее установленной и не отложена
  /// ([snooze] с [dismissedAt] для той же [dismissedBuild]); ссылка — APK
  /// первого ABI устройства из манифеста, иначе [apkDownloadUri].
  @visibleForTesting
  static AppUpdateOffer? offerFrom(
    Map<String, Object?> manifest, {
    required int currentBuild,
    required List<String> abis,
    required int dismissedBuild,
    required DateTime dismissedAt,
    required DateTime now,
  }) {
    final version = manifest['version'];
    final build = manifest['build'];
    if (version is! String || build is! int || build <= currentBuild) return null;
    if (build == dismissedBuild && now.difference(dismissedAt) < snooze) return null;
    final apks = manifest['apks'];
    Uri? uri;
    if (apks is Map) {
      for (final abi in abis) {
        final url = (apks[abi] as Map?)?['url'];
        if (url is String) {
          uri = Uri.tryParse(url);
          break;
        }
      }
    }
    return AppUpdateOffer(version: version, build: build, uri: uri ?? apkDownloadUri(abis));
  }

  @visibleForTesting
  Future<void> dispose() async {
    _timer?.cancel();
    await _connectivity?.cancel();
    _started = false;
  }
}
