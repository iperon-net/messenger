import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/models/mapper.dart';

import '../../constants.dart';

part 'settings_blocked_state.mapper.dart';

/// Заблокированный пользователь в списке: userID и имя по общему правилу.
@MappableClass(includeCustomMappers: [Uint8ListMapper()])
class BlockedUser with BlockedUserMappable {
  final Uint8List userID;
  final String name;

  const BlockedUser({required this.userID, required this.name});
}

/// «Конфиденциальность» → «Заблокированные».
@MappableClass()
class SettingsBlockedState with SettingsBlockedStateMappable {
  final Status status;
  final List<BlockedUser> users;

  /// Растёт, когда разблокировать не удалось (нет сети / ошибка сервера) —
  /// экран показывает «Нет соединения».
  final int offlineNotice;

  const SettingsBlockedState({this.status = Status.initialization, this.users = const [], this.offlineNotice = 0});
}
