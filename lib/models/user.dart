import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';


@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    @Default("") String userID,
    @Default("") String phoneNumber,
    @Default([]) List<int> session,
    @Default([]) List<SharedKey> sharedKeys,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();
  factory User.fromSqlite(Map<String, dynamic> data) => User.fromJson(data);

  SharedKey getSharedKey() {
    return sharedKeys.firstWhere((item) => item.expiredAt == null);
  }
}

@freezed
abstract class SharedKey with _$SharedKey {
  const SharedKey._();

  const factory SharedKey({
    @Default("") String sharedKeyID,
    @Default([]) List<int> sharedKey,
    DateTime? expiredAt,
  }) = _SharedKey;

  factory SharedKey.fromJson(Map<String, dynamic> json) => _$SharedKeyFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();
  factory SharedKey.fromSqlite(Map<String, dynamic> data) => SharedKey.fromJson(data);
}
