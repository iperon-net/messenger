import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_cubit.dart';
import 'settings_screen_cupertino.dart';
import 'settings_screen_material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsCubit()..loading(),
      child: Platform.isIOS ? SettingsScreenCupertino() : SettingsScreenMaterial()
    );
  }

}
