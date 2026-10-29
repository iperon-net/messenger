import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../i18n/translations.g.dart';

/// Данные экрана «Аккаунт заблокирован» — из query маршрута `/auth/blocked`
/// (их собирает `accountBlockedURI` из трейлера ответа сервера).
class AuthBlockedInfo {
  /// Категория блокировки (`spam`, `fraud`, …); пусто — не пришла.
  final String reason;

  /// Конец блокировки; `null` — навсегда или не пришло (см. [known]).
  final DateTime? until;

  /// Контакт поддержки: почта или ссылка; пусто — не пришёл.
  final String support;

  const AuthBlockedInfo({this.reason = "", this.until, this.support = ""});

  factory AuthBlockedInfo.fromQuery(Map<String, String> query) {
    final seconds = int.tryParse(query["until"] ?? "");

    return AuthBlockedInfo(
      reason: query["reason"] ?? "",
      until: seconds == null ? null : DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
      support: query["support"] ?? "",
    );
  }

  /// Сервер прислал подробности (старый сервер / вход по звонку без
  /// AUTH_CONFIRMATION — только общий текст).
  bool get known => reason.isNotEmpty;

  /// «Причина: спам» (неизвестная категория — «нарушение правил»).
  String reasonText(Translations t) {
    final reasons = t.screenAuthBlocked.reasons;
    final label = switch (reason) {
      "spam" => reasons.spam,
      "fraud" => reasons.fraud,
      "abuse" => reasons.abuse,
      "illegal" => reasons.illegal,
      _ => reasons.rules,
    };

    return t.screenAuthBlocked.reason(reason: label);
  }

  /// «Блокировка действует до 05.11.2026 14:20.» / «Блокировка бессрочная.»
  String termText(Translations t) {
    final end = until;
    if (end == null) return t.screenAuthBlocked.forever;

    return t.screenAuthBlocked.until(date: DateFormat('dd.MM.yyyy HH:mm').format(end.toLocal()));
  }

  /// Открыть контакт поддержки: почту — в почтовом клиенте, ссылку — в браузере.
  Future<void> openSupport() async {
    final uri = support.contains('@') && !support.contains('://') ? Uri(scheme: 'mailto', path: support) : Uri.tryParse(support);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
