import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../di.dart';
import '../logger.dart';
import '../repositories.dart';
import 'bootstrap_file.dart';

/// Адреса серверов по окружениям из подписанного `config.json`
/// (docs/plans/bootstrap-config.md, этап 2) вместо Remote Config. Окружение —
/// свойство аккаунта (`accounts.environment`); [Settings] отдаёт адрес
/// окружения активного аккаунта.
///
/// Значения: кэш файла в `device.db` ([load], до первого подключения), без
/// него — [builtIn]. Свежий файл скачивается в фоне ([refresh]) и действует
/// со следующего подключения (переключение аккаунта, перезапуск): уже
/// открытый канал не пересоздаётся.
class BootstrapConfig {
  BootstrapConfig._();

  /// Зашито в сборку: первый запуск и окружение, которого нет в файле.
  static const builtIn = BootstrapFile(
    serial: 0,
    issuedAt: 0,
    defaultEnvironment: 'staging',
    environments: {
      'staging': BootstrapEnvironment(
        api: [BootstrapApi(host: 'staging.iperon.net', port: 443, secure: true)],
        serverKeyFingerprint: '7abfc2a7e8ea09ae384bdeb855cfeae24d60bfac3646046e754fddc8d5ab604d',
        mldsaKeyFingerprint: 'e14b67f0691cfdcdb5a29fdc44c6c7f225f07b88f574821473b27b84f15894c7',
      ),
    },
  );

  /// Повторно не качать чаще (старты, переключения аккаунтов).
  static const _minInterval = Duration(minutes: 10);

  static BootstrapFile _file = builtIn;
  static BootstrapConfigCache? _cache;
  static DateTime? _checkedAt;
  static Future<bool?>? _refreshing;

  /// Действующий файл ([builtIn], пока не было ни кэша, ни загрузки).
  static BootstrapFile get file => _file;

  /// Окружение новых аккаунтов.
  static String get defaultEnvironment => _file.defaultEnvironment;

  /// Известные окружения (из файла и сборки) по алфавиту.
  static List<String> get environments => {..._file.environments.keys, ...builtIn.environments.keys}.toList()..sort();

  /// Адреса окружения [name]; нет ни в файле, ни в сборке (удалили из файла) —
  /// окружение по умолчанию.
  static BootstrapEnvironment environment(String name) {
    final found = _file.environments[name] ?? builtIn.environments[name];
    if (found != null) return found;
    getIt.get<Logger>().warning('bootstrap: unknown environment "$name", using $defaultEnvironment');
    return _file.environments[defaultEnvironment] ?? builtIn.environments[builtIn.defaultEnvironment]!;
  }

  /// Кэш с прошлой загрузки (из `DeviceRepositories`, до слотов аккаунтов).
  /// Подпись проверяется заново: файл в базе не доверенный сам по себе.
  static Future<void> load(BootstrapConfigCache cache) async {
    _cache = cache;
    try {
      final text = await cache.get();
      if (text == null) return;
      _file = await BootstrapFile.verify(text);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace, 'bootstrap: cache');
    }
  }

  /// Скачать свежий файл (не чаще [_minInterval], [force] — мимо). Null —
  /// не скачался ни с одного зеркала; иначе — поменялся ли.
  static Future<bool?> refresh({bool force = false}) {
    final checked = _checkedAt;
    if (!force && checked != null && DateTime.now().difference(checked) < _minInterval) return Future.value(false);
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  static Future<bool?> _refresh() async {
    final logger = getIt.get<Logger>();
    _checkedAt = DateTime.now();
    final download = await fetchBootstrapFile(
      fetch: _get,
      currentSerial: _file.serial,
      onSkip: (uri, reason) => logger.debug('bootstrap: $uri skipped: $reason'),
    );
    if (download == null) return null;
    if (download.file.serial == _file.serial) return false;
    _file = download.file;
    await _cache?.put(download.text, download.file.serial);
    logger.info('bootstrap: serial ${_file.serial}, default ${_file.defaultEnvironment}, ${_file.environments.keys.join(', ')}');
    return true;
  }

  static Future<String> _get(Uri uri) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final response = await (await client.getUrl(uri)).close().timeout(const Duration(seconds: 5));
      if (response.statusCode != HttpStatus.ok) throw HttpException('status ${response.statusCode}', uri: uri);
      // Файл — несколько сотен байт; больше — не он.
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 5))) {
        bytes.addAll(chunk);
        if (bytes.length > 64 * 1024) throw HttpException('too large', uri: uri);
      }
      return utf8.decode(bytes);
    } finally {
      client.close(force: true);
    }
  }
}
