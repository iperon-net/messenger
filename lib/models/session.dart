import 'package:dart_mappable/dart_mappable.dart';
import 'package:objectid/objectid.dart';

import 'mapper.dart';

part 'session.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class Session with SessionMappable {
  final List<int> session;
  final List<int> userID;
  final List<int> sharedKey;
  final List<int> salt;
  final bool isActive;

  const Session({
    this.session = const [],
    this.userID = const [],
    this.sharedKey = const [],
    this.salt = const [],
    this.isActive = false,
  });

  ObjectId getUserIDObjectID() {
    return ObjectId.fromBytes(userID);
  }

  @override
  String toString() {
    return "session=$session userID=$userID, sharedKey=$sharedKey, salt=$salt";
  }

}
