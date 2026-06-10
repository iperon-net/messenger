import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'session.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class Session with SessionMappable {
  final List<int> session;
  final List<int> userID;
  final List<int> sharedKey;
  final List<int> sharedSalt;
  final bool isActive;

  const Session({
    this.session = const [],
    this.userID = const [],
    this.sharedKey = const [],
    this.sharedSalt = const [],
    this.isActive = false,
  });

}
