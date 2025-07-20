import 'dart:io';

import 'package:flutter/widgets.dart';

import 'passcode_screen_cupertino.dart';
import 'passcode_screen_material.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? PasscodeScreenCupertino() : PasscodeScreenMaterial();
}
