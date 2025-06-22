// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: json['userId'] as String,
  email: json['email'] as String,
  sessionToken: json['sessionToken'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'sessionToken': instance.sessionToken,
  'isActive': instance.isActive,
};
