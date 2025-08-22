import 'dart:io';

import 'package:flutter/widgets.dart';

import 'lock_screen_cupertino.dart';
import 'lock_screen_material.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? LockScreenCupertino() : LockScreenMaterial();
}
