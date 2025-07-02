import 'dart:io';

import 'package:flutter/widgets.dart';

import 'appearance_screen_cupertino.dart';
import 'appearance_screen_material.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? AppearanceScreenCupertino() : AppearanceScreenMaterial();
}
