import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'user.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class User with UserMappable {
  final List<int> userID;
  final String phoneNumber;

  const User({
    this.userID = const [],
    this.phoneNumber = "",
  });
}
