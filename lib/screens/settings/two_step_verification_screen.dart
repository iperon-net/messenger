import 'dart:io';

import 'package:flutter/widgets.dart';

import 'two_step_verification_screen_cupertino.dart';
import 'two_step_verification_screen_material.dart';

class TwoStepVerificationScreen extends StatelessWidget {
  const TwoStepVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? TwoStepVerificationScreenCupertino() : TwoStepVerificationScreenMaterial();
}
