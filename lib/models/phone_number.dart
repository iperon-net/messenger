import 'package:dart_mappable/dart_mappable.dart';

part 'phone_number.mapper.dart';

@MappableClass()
class PhoneNumberModel with PhoneNumberModelMappable {
  final String international;
  final String national;
  final String e164;
  final String rfc3966;
  final String raw;

  const PhoneNumberModel({
    required this.international,
    required this.national,
    required this.e164,
    required this.rfc3966,
    required this.raw,
  });
}
