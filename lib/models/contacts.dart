import 'dart:math';
import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

import 'mapper.dart';

part 'contacts.mapper.dart';

final List<Color> _colors = [
  Colors.red,
  Colors.redAccent,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.purple,
  Colors.purpleAccent,
  Colors.blue,
  Colors.blueAccent,
  Colors.lightBlue,
  Colors.lightBlueAccent,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.blueGrey,
  Colors.green,
  Colors.lightGreen,
  Colors.teal,
  Colors.amber,
  Colors.purple,
  Colors.purpleAccent,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.brown,
  Colors.brown.shade400,
  Colors.brown.shade600,
  Colors.grey,
  Colors.grey.shade400,
  Colors.grey.shade600,
  Colors.amber,
  Colors.orange,
  Colors.orangeAccent,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.red.shade300,
  Colors.red.shade700,
  Colors.blue.shade300,
  Colors.blue.shade700,
  Colors.green.shade300,
  Colors.green.shade700,
  Colors.purple.shade300,
  Colors.purple.shade700,
  Colors.orange.shade300,
  Colors.orange.shade700,
  Colors.teal.shade700,
  Colors.pink.shade300,
  Colors.pink.shade700,
  Colors.indigo.shade300,
  Colors.indigo.shade700,
  Colors.cyan.shade700,
];

@MappableClass(includeCustomMappers: [BoolMapper()])
class ContactPhoneNumber with ContactPhoneNumberMappable {
  final String international;
  final String national;
  final String e164;
  final String rfc3966;

  const ContactPhoneNumber({required this.international, required this.national, required this.e164, required this.rfc3966});

  @override
  String toString() {
    return "international=$international, national=$national, e164=$e164, rfc3966=$rfc3966";
  }

}

@MappableClass(includeCustomMappers: [BoolMapper()])
class Contact with ContactMappable {
  final String contactID;
  final List<int> userID;
  final String firstName;
  final String lastName;
  final DateTime lastSeenAt;
  final bool isOnline;
  final List<ContactPhoneNumber> phoneNumbers;
  final String username;
  final DateTime birthDate;
  late final int avatarColor;

  final Random _random = Random();

  Contact({
    this.contactID = "",
    this.userID = const [],
    this.firstName = "",
    this.lastName = "",
    DateTime? lastSeenAt,
    this.isOnline = false,
    this.phoneNumbers = const [],
    this.username = "",
    DateTime? birthDate,
    this.avatarColor = 0,
  }): lastSeenAt = lastSeenAt ?? DateTime.fromMicrosecondsSinceEpoch(0), birthDate = birthDate ?? DateTime.fromMicrosecondsSinceEpoch(0);

  Color getAvatarColor() {
    if (avatarColor > 0) return Color(avatarColor);

    final color = _colors[_random.nextInt(_colors.length)];
    avatarColor = color.toARGB32();
    return color;
  }

  @override
  String toString() {
    return "contactID=$contactID, userID=$userID, firstName=$firstName, lastName=$lastName, lastSeenAt=$lastSeenAt, isOnline=$isOnline,"
        " phoneNumber=${phoneNumbers.toString()}";
  }

}
