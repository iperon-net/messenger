import 'dart:io';

import 'package:flutter/widgets.dart';

import 'privacy_and_security_screen_cupertino.dart';
import 'privacy_and_security_screen_material.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? PrivacyAndSecurityScreenCupertino() : PrivacyAndSecurityScreenMaterial();
}
