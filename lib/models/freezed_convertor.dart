import 'package:freezed_annotation/freezed_annotation.dart';

class BoolConverter implements JsonConverter<bool, int> {
  const BoolConverter();

  @override
  bool fromJson(int value) => value != 0;

  @override
  int toJson(bool value) => value ? 1 : 0;

  bool fromSqlite(int value) => value != 0;

  int toSqlite(bool value) => value ? 1 : 0;

}
