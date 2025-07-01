import 'dart:io';

import 'package:flutter/widgets.dart';

import 'language_screen_cupertino.dart';
import 'language_screen_material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? LanguageScreenCupertino() : LanguageScreenMaterial();
  }
}
