import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'user.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class User with UserMappable {
  final List<int> userID;
  final String phoneNumber;
  final List<int> salt;

  const User({
    this.userID = const [],
    this.phoneNumber = "",
    this.salt = const [],
  });
}
