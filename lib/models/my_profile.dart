import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'my_profile.mapper.dart';

@MappableClass(includeCustomMappers: [EpochDateTimeMapper()])
class MyProfile with MyProfileMappable {
  final List<int> userID;
  final String username;
  final String fistName;
  final String lastName;
  final DateTime? birthDate;
  final String aboutMe;

  const MyProfile({this.userID = const [], this.username = "", this.fistName = "", this.lastName = "", this.birthDate, this.aboutMe = ""});
}
