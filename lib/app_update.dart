import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
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

  /// sha256 (hex) и размер APK из манифеста; без sha256 ставить из приложения
  /// нельзя — только ссылка в браузере.
  final String? sha256;
  final int? size;

  const AppUpdateOffer({required this.version, required this.build, required this.uri, this.sha256, this.size});
}

/// Чем закончилось «Обновить» из приложения.
enum AppUpdateInstallResult {
  /// Окно установки показано и закрыто без установки («Отмена»).
  aborted,

  /// Загрузку остановили.
  cancelled,

  /// Не скачалось, не сошёлся sha256 или установщик отказал.
  failed,
}

/// Мягкое уведомление о новой версии (этапы 2–3 docs/plans/app-updates.md).
/// Пока только канал APK: манифест `latest.json` последнего релиза (его кладёт
/// CI, `_deploy_android.yaml`; раздаёт nginx download.iperon.net). Магазины —
/// своими API (этапы 4–5), macOS — Sparkle, iOS (TestFlight сам сообщает о
/// сборках) — без баннера. Проверка — при старте, при появлении сети и раз в
/// [_interval], пока приложение на экране; без сети — молча пропускается.
/// «Обновить» на Android качает APK сам (прогресс в [download], sha256 из
/// манифеста) и отдаёт его системному установщику (AppUpdate.kt); вопросы
/// пользователю (мобильная сеть, разрешение на установку) задаёт экран.
class AppUpdates {
  AppUpdates._();

  static final instance = AppUpdates._();

  static const _interval = Duration(hours: 6);

  /// «Позже» прячет баннер этой версии на столько.
  static const snooze = Duration(hours: 24);

  static final manifestUri = Uri.parse('$appDownloadHost/android/latest.json');

  /// null — обновления нет (или его отложили).
  final available = ValueNotifier<AppUpdateOffer?>(null);

  /// Загрузка APK: доля 0…1 (0 — размер неизвестен); null — не идёт.
  final download = ValueNotifier<double?>(null);

  bool _cancelled = false;

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
      final offer = offerFrom(
        manifest,
        currentBuild: current,
        abis: source.abis,
        dismissedBuild: dismissed.build,
        dismissedAt: DateTime.fromMillisecondsSinceEpoch(dismissed.at),
        now: DateTime.now(),
      );
      if (download.value == null) available.value = offer;
      // Обновились (или версию отозвали) — скачанный APK больше не нужен.
      if (manifest['build'] is int && manifest['build'] as int <= current) await _clearDownloads();
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
    cancelDownload();
    available.value = null;
    await getIt.get<DeviceRepositories>().settingsDevice.setUpdateDismissed(build: offer.build, at: DateTime.now().millisecondsSinceEpoch);
  }

  /// «Обновить» без установки из приложения: APK в браузере, установка —
  /// системным окном (iOS-баннера нет, запасной путь при ошибке).
  Future<void> openInBrowser() async {
    final offer = available.value;
    if (offer == null) return;
    try {
      await launchUrl(offer.uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'app update: open apk');
    }
  }

  /// Можно ли ставить [offer] из приложения: Android и sha256 в манифесте.
  bool canInstallInApp(AppUpdateOffer offer) => Platform.isAndroid && offer.sha256 != null;

  /// Только мобильная сеть (без Wi-Fi / Ethernet) — спросить перед загрузкой.
  Future<bool> onMobileNetwork() async {
    final results = await Connectivity().checkConnectivity();
    return results.contains(ConnectivityResult.mobile) &&
        !results.contains(ConnectivityResult.wifi) &&
        !results.contains(ConnectivityResult.ethernet);
  }

  Future<bool> canInstallPackages() => appCanInstallPackages();

  /// Открыть «Установка неизвестных приложений» и дождаться возврата в
  /// приложение; true — разрешение дали.
  Future<bool> requestInstallPermission() async {
    final returned = Completer<void>();
    final listener = AppLifecycleListener(onResume: () => returned.isCompleted ? null : returned.complete());
    try {
      await appOpenInstallSettings();
      await returned.future;
    } finally {
      listener.dispose();
    }
    return appCanInstallPackages();
  }

  /// Скачать APK (с прогрессом в [download]), сверить sha256 и показать окно
  /// установки. При успехе процесс завершает система — возврата нет.
  Future<AppUpdateInstallResult> downloadAndInstall() async {
    final offer = available.value;
    if (offer == null || offer.sha256 == null || download.value != null) return AppUpdateInstallResult.cancelled;
    _cancelled = false;
    download.value = 0;
    try {
      final file = await _download(offer);
      if (file == null) return AppUpdateInstallResult.cancelled;
      final result = await appInstallApk(file.path);
      if (result.aborted) return AppUpdateInstallResult.aborted;
      getIt.get<Logger>().warning('app update: install failed: ${result.message}');
      return AppUpdateInstallResult.failed;
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'app update: download and install');
      return AppUpdateInstallResult.failed;
    } finally {
      download.value = null;
    }
  }

  void cancelDownload() => _cancelled = true;

  Future<Directory> _downloadsDir() async => Directory('${(await getTemporaryDirectory()).path}/app_update');

  Future<void> _clearDownloads() async {
    final dir = await _downloadsDir();
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  /// APK этой сборки во временной папке; уже скачанный и целый — повторно не
  /// качаем. null — загрузку отменили.
  Future<File?> _download(AppUpdateOffer offer) async {
    final dir = await _downloadsDir();
    final file = File('${dir.path}/Iperon-${offer.build}.apk');
    if (await file.exists() && await _sha256(file.openRead()) == offer.sha256!.toLowerCase()) return file;
    await _clearDownloads();
    await dir.create(recursive: true);

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    final hash = Sha256().newHashSink();
    final sink = file.openWrite();
    try {
      final response = await (await client.getUrl(offer.uri)).close().timeout(const Duration(seconds: 30));
      if (response.statusCode != HttpStatus.ok) throw HttpException('status ${response.statusCode}', uri: offer.uri);
      final total = response.contentLength > 0 ? response.contentLength : (offer.size ?? 0);
      var received = 0;
      // Зависшая загрузка: 30 с без данных — ошибка.
      await for (final chunk in response.timeout(const Duration(seconds: 30))) {
        if (_cancelled) break;
        sink.add(chunk);
        hash.add(chunk);
        received += chunk.length;
        if (total > 0) download.value = (received / total).clamp(0, 1).toDouble();
      }
      await sink.close();
      hash.close();
      if (_cancelled) {
        await _clearDownloads();
        return null;
      }
      final digest = getIt.get<Utils>().bytesToHex(Uint8List.fromList((await hash.hash()).bytes));
      if (digest != offer.sha256!.toLowerCase()) {
        await _clearDownloads();
        throw StateError('app update: sha256 mismatch');
      }
      return file;
    } catch (_) {
      await sink.close().catchError((_) {});
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  Future<String> _sha256(Stream<List<int>> data) async {
    final hash = Sha256().newHashSink();
    await for (final chunk in data) {
      hash.add(chunk);
    }
    hash.close();
    return getIt.get<Utils>().bytesToHex(Uint8List.fromList((await hash.hash()).bytes));
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
    if (apks is Map) {
      for (final abi in abis) {
        final apk = apks[abi];
        final uri = apk is Map && apk['url'] is String ? Uri.tryParse(apk['url'] as String) : null;
        if (uri == null) continue;
        final sha256 = apk['sha256'], size = apk['size'];
        return AppUpdateOffer(
          version: version,
          build: build,
          uri: uri,
          sha256: sha256 is String && sha256.length == 64 ? sha256 : null,
          size: size is int ? size : null,
        );
      }
    }
    return AppUpdateOffer(version: version, build: build, uri: apkDownloadUri(abis));
  }

  @visibleForTesting
  Future<void> dispose() async {
    _timer?.cancel();
    await _connectivity?.cancel();
    _started = false;
  }
}
