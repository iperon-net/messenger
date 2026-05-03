import 'package:flutter/material.dart';

import '../../di.dart';
import '../../logger.dart';

class SettingsMaterialScreen extends StatefulWidget {
  const SettingsMaterialScreen({super.key});

  @override
  State<SettingsMaterialScreen> createState() => _SettingsMaterialScreen();
}

class _SettingsMaterialScreen extends State<SettingsMaterialScreen> {
  final logger = getIt.get<Logger>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    logger.debug("initState home");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text("d");
  }

}
