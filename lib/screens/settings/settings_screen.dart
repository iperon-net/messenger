import 'dart:io';

import 'package:flutter/widgets.dart';

import 'settings_screen_cupertino.dart';
import 'settings_screen_material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? SettingsScreenCupertino() : SettingsScreenMaterial();
}
