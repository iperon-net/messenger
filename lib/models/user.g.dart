// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) =>
    _Profile(isDelete: json['isDelete'] as bool);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'isDelete': instance.isDelete,
};

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  userId: json['userId'] as String,
  email: json['email'] as String,
  sessionToken: json['sessionToken'] as String,
  isActive: json['isActive'] as bool,
  profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'sessionToken': instance.sessionToken,
  'isActive': instance.isActive,
  'profile': instance.profile.toJson(),
};
