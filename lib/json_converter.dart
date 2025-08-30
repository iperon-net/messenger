import 'package:json_annotation/json_annotation.dart';

class ConverterBoolean implements JsonConverter<bool, int> {
  const ConverterBoolean();

  @override
  bool fromJson(int json) => json == 1 ? true : false;

  @override
  int toJson(bool object) => object == true ? 1 : 0;
}

class ConverterEpochDateTime implements JsonConverter<DateTime, int> {
  const ConverterEpochDateTime();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
