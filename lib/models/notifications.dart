import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications.freezed.dart';
part 'notifications.g.dart';

@freezed
abstract class NotificationMessage with _$NotificationMessage {
  const NotificationMessage._();
  @JsonSerializable(explicitToJson: true)

  const factory NotificationMessage({
    required String title,
    required String body,
  }) = _NotificationMessage;

  factory NotificationMessage.fromJson(Map<String, dynamic> json) => _$NotificationMessageFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();
  factory NotificationMessage.fromSqlite(Map<String, dynamic> data) => NotificationMessage.fromJson(data);
}
