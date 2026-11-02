import 'package:dart_mappable/dart_mappable.dart';

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as pb;

import '../protobuf.dart' as models_pb;
import 'mapper.dart';

part 'emoji_status.mapper.dart';

@MappableClass(includeCustomMappers: [EpochDateTimeMapper(), BoolMapper()])
class EmojiStatus with EmojiStatusMappable {
  final String emoji;
  final DateTime? expiresAt;
  final bool doNotDisturb;

  const EmojiStatus({this.emoji = '', this.expiresAt, this.doNotDisturb = false});

  factory EmojiStatus.fromProto(models_pb.EmojiStatus? status) {
    if (status == null || status.emoji.isEmpty) return const EmojiStatus();
    return EmojiStatus(
      emoji: status.emoji,
      expiresAt: status.hasExpiresAt() ? status.expiresAt.toDateTime(toLocal: true) : null,
      doNotDisturb: status.doNotDisturb,
    );
  }

  bool get active => emoji.isNotEmpty && (expiresAt == null || expiresAt!.isAfter(DateTime.now()));
  bool get mutes => active && expiresAt != null && doNotDisturb;

  models_pb.EmojiStatus? toProto() {
    if (!active) return null;
    return models_pb.EmojiStatus(
      emoji: emoji,
      expiresAt: expiresAt == null ? null : pb.Timestamp.fromDateTime(expiresAt!.toUtc()),
      doNotDisturb: doNotDisturb,
    );
  }
}
