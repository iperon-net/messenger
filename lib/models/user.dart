import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String userID;
  final String phoneNumber;
  final List<int> session;
  final List<SharedKey> sharedKeys;

  const User({
    this.userID = "",
    this.phoneNumber = "",
    this.session = const [],
    this.sharedKeys = const [],
  });

  factory User.fromSqlite(Map<String, dynamic> data) => User(
    userID: data['userID'] as String? ?? '',
    phoneNumber: data['phoneNumber'] as String? ?? '',
    session: _toIntList(data['session']),
    sharedKeys: (data['sharedKeys'] as List<Object?>?)
            ?.cast<Map<String, Object?>>()
            .map(SharedKey.fromSqlite)
            .toList() ??
        [],
  );

  SharedKey getSharedKey() {
    return sharedKeys.firstWhere((item) => item.expiredAt == null);
  }
}

@MappableClass()
class SharedKey with SharedKeyMappable {
  final String sharedKeyID;
  final List<int> sharedKey;
  final DateTime? expiredAt;

  const SharedKey({
    this.sharedKeyID = "",
    this.sharedKey = const [],
    this.expiredAt,
  });

  factory SharedKey.fromSqlite(Map<String, Object?> data) => SharedKey(
    sharedKeyID: data['sharedKeyID'] as String? ?? '',
    sharedKey: _toIntList(data['sharedKey']),
    expiredAt: data['expiredAt'] != null
        ? DateTime.parse(data['expiredAt'] as String)
        : null,
  );
}

List<int> _toIntList(Object? value) {
  if (value == null) return [];
  if (value is List<int>) return value;
  return (value as List).cast<int>();
}
