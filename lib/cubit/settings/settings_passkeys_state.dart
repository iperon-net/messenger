import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_passkeys_state.mapper.dart';

/// Один ключ доступа в списке (плоская проекция proto PasskeyCredential для UI).
@MappableClass()
class PasskeyItem with PasskeyItemMappable {
  final List<int> credentialId;
  final String label;
  final List<int> aaguid;
  final int createdAt; // unix-секунды
  final int lastUsedAt; // unix-секунды, 0 — ни разу

  const PasskeyItem({this.credentialId = const [], this.label = "", this.aaguid = const [], this.createdAt = 0, this.lastUsedAt = 0});
}

@MappableClass()
class SettingsPasskeysState with SettingsPasskeysStateMappable {
  // status — жизненный цикл загрузки списка; networkStatus — add/delete в полёте.
  final Status status;
  final Status networkStatus;
  final bool loadError;
  // Загрузка списка не прошла из-за отсутствия сети (а не ошибки сервера) —
  // показываем отдельную offline-страницу вместо списка/inline loadError.
  final bool offline;
  final List<PasskeyItem> items;
  final String error;

  const SettingsPasskeysState({
    this.status = Status.initialization,
    this.networkStatus = Status.success,
    this.loadError = false,
    this.offline = false,
    this.items = const [],
    this.error = "",
  });
}
