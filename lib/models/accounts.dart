import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounts.freezed.dart';
part 'accounts.g.dart';

@freezed
abstract class Account with _$Account {
  const Account._();
  @JsonSerializable(explicitToJson: true)

  const factory Account({
    required String accountId,
    required int phone,
    required String lastName,
    required String firstName,
    required String username,
    required String bio,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();
  factory Account.fromSqlite(Map<String, dynamic> data) => Account.fromJson(data);
}
