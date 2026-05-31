import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final List<int> userID;
  final String phoneNumber;
  final bool isActive;

  const User({
    this.userID = const [],
    this.phoneNumber = "",
    this.isActive = false,
  });

  factory User.fromSqlite(Map<String, dynamic> data) {
    final userID = data['userID'] ?? [];
    final phoneNumber = data['phoneNumber'] ?? "";
    final isActive = data['isActive'] ?? false;

    return User(userID: userID, phoneNumber: phoneNumber, isActive: isActive);
  }
}
