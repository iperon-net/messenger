// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    _NotificationMessage(
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$NotificationMessageToJson(
  _NotificationMessage instance,
) => <String, dynamic>{'title': instance.title, 'body': instance.body};
