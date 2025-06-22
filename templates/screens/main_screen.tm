import 'dart:io';

import 'package:flutter/widgets.dart';

import '{name}[-c]_screen_cupertino.dart';
import '{name}[-c]_screen_material.dart';

class {name}[-C]Screen extends StatelessWidget {
  const {name}[-C]Screen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? {name}[-C]ScreenCupertino() : {name}[-C]ScreenMaterial();
}
