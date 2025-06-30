// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  accountId: json['accountId'] as String,
  phone: (json['phone'] as num).toInt(),
  lastName: json['lastName'] as String,
  firstName: json['firstName'] as String,
  username: json['username'] as String,
  bio: json['bio'] as String,
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'accountId': instance.accountId,
  'phone': instance.phone,
  'lastName': instance.lastName,
  'firstName': instance.firstName,
  'username': instance.username,
  'bio': instance.bio,
};
