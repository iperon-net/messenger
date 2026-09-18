import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'profile.mapper.dart';

/// Публичный профиль чужого пользователя (кэш таблицы `profiles`). В отличие от
/// [MyProfile] содержит номер телефона (`phoneNumber`), который сервер отдаёт
/// только при публичном просмотре.
@MappableClass(includeCustomMappers: [EpochDateTimeMapper()])
class Profile with ProfileMappable {
  final List<int> userID;
  final String username;
  final String fistName;
  final String lastName;
  final DateTime? birthDate;
  final String aboutMe;
  final String phoneNumber;

  /// `cdn_id` привязанного аватара (колонка `avatarCdnID`, FK на
  /// `downloads(cdnID)`). `null`, пока аватар не задан. По нему [CDNManager]
  /// достаёт уже расшифрованный файл из media-кэша без обращения к сети.
  final List<int>? avatarCdnID;

  /// Кэш last-seen (последний уход в оффлайн). Для показа даты последнего визита
  /// на cold-start / без сети, пока не пришёл снимок присутствия. `null`, если
  /// ещё не знаем. online здесь НЕ храним — он эфемерный.
  final DateTime? lastSeenAt;

  const Profile({
    this.userID = const [],
    this.username = "",
    this.fistName = "",
    this.lastName = "",
    this.birthDate,
    this.aboutMe = "",
    this.phoneNumber = "",
    this.avatarCdnID,
    this.lastSeenAt,
  });
}
