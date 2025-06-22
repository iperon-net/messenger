import 'dart:io';

import 'package:flutter/widgets.dart';

import 'home_screen_cupertino.dart';
import 'home_screen_material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Platform.isIOS ? HomeScreenCupertino() : HomeScreenMaterial();
}
