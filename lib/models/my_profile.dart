import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';
import 'emoji_status.dart';

part 'my_profile.mapper.dart';

@MappableClass(includeCustomMappers: [EpochDateTimeMapper(), BoolMapper()])
class MyProfile with MyProfileMappable {
  final List<int> userID;
  final String username;
  final String fistName;
  final String lastName;
  final DateTime? birthDate;
  final String aboutMe;
  final String emojiStatus;
  final DateTime? emojiStatusExpiresAt;
  final bool emojiStatusDoNotDisturb;

  EmojiStatus get status => EmojiStatus(emoji: emojiStatus, expiresAt: emojiStatusExpiresAt, doNotDisturb: emojiStatusDoNotDisturb);

  /// `cdn_id` привязанного аватара (колонка `avatarCdnID`, FK на
  /// `downloads(cdnID)`). `null`, пока аватар не задан. По нему [CDNManager]
  /// достаёт уже расшифрованный файл из media-кэша без обращения к сети.
  final List<int>? avatarCdnID;

  const MyProfile({
    this.userID = const [],
    this.username = "",
    this.fistName = "",
    this.lastName = "",
    this.birthDate,
    this.aboutMe = "",
    this.emojiStatus = "",
    this.emojiStatusExpiresAt,
    this.emojiStatusDoNotDisturb = false,
    this.avatarCdnID,
  });
}
