import 'dart:io';

import 'package:flutter/widgets.dart';

import 'contacts_screen_cupertino.dart';
import 'contacts_screen_material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? ContactsScreenCupertino() : ContactsScreenMaterial();
}
