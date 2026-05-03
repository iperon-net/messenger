// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userID: json['userID'] as String? ?? "",
  phoneNumber: json['phoneNumber'] as String? ?? "",
  session:
      (json['session'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  sharedKeys:
      (json['sharedKeys'] as List<dynamic>?)
          ?.map((e) => SharedKey.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userID': instance.userID,
  'phoneNumber': instance.phoneNumber,
  'session': instance.session,
  'sharedKeys': instance.sharedKeys,
};

_SharedKey _$SharedKeyFromJson(Map<String, dynamic> json) => _SharedKey(
  sharedKeyID: json['sharedKeyID'] as String? ?? "",
  sharedKey:
      (json['sharedKey'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  expiredAt: json['expiredAt'] == null
      ? null
      : DateTime.parse(json['expiredAt'] as String),
);

Map<String, dynamic> _$SharedKeyToJson(_SharedKey instance) =>
    <String, dynamic>{
      'sharedKeyID': instance.sharedKeyID,
      'sharedKey': instance.sharedKey,
      'expiredAt': instance.expiredAt?.toIso8601String(),
    };
