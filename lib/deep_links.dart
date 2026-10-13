import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Ссылки `https://iperon.net/<путь>`, открывшие приложение снаружи
/// (Universal Links на iOS, App Links на Android).
///
/// Система отдаёт их Flutter как адрес маршрута (встроенный deep linking —
/// при холодном старте начальный маршрут, иначе `pushRouteInformation`), а
/// такого маршрута в роутере нет. Поэтому `redirect` роутера отдаёт адрес
/// сюда ([capture]) и уводит на «Чаты» (или на вход); открывает ссылку
/// `DeepLinkGate` в шелле вкладок, когда пользователь вошёл.
class DeepLinks extends ChangeNotifier {
  DeepLinks._();

  static final DeepLinks instance = DeepLinks._();

  /// Верхние пути роутера: это разделы приложения, а не ссылки (на сервере
  /// такие имена пользователей заняты — `reservedUsernames`).
  static const _appPaths = {'auth', 'chats', 'calls', 'contacts', 'settings', 'call', 'profile'};

  Uri? _pending;

  /// Внешняя ли это ссылка на iperon.net: да — запомнить до открытия
  /// ([take]) и вернуть `true`.
  bool capture(Uri uri) {
    final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
    if (host.isNotEmpty && host != 'iperon.net') return false;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty || _appPaths.contains(segments.first)) return false;
    _pending = Uri(scheme: 'https', host: 'iperon.net', pathSegments: segments, query: uri.hasQuery ? uri.query : null);
    // Из redirect роутера — слушатели узнают после кадра.
    SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    return true;
  }

  /// Ссылка, ждущая открытия (и забыть её).
  Uri? take() {
    final pending = _pending;
    _pending = null;
    return pending;
  }
}
