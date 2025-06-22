import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';


@freezed
abstract class Profile with _$Profile {
  const Profile._();
  @JsonSerializable(explicitToJson: true)

  const factory Profile({
    required bool isDelete,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

}

@freezed
abstract class User with _$User {
  const User._();
  @JsonSerializable(explicitToJson: true)

  const factory User({
    required String userId,
    required String email,
    required String sessionToken,
    required bool isActive,
    required Profile profile,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toSqlite() {
    Map<String, dynamic> data = toJson();
    data["isActive"] ? data["isActive"] = 1 : data["isActive"] = 0;
    data.remove("profile");
    return data;
  }

  factory User.fromSqlite(Map<String, dynamic> data) {
    data["isActive"] == 1 ? data["isActive"] = true : data["isActive"] = false;
    return User.fromJson(data);
  }

}
