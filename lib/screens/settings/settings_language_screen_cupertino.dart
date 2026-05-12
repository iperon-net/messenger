import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/translations.g.dart';

class SettingsLanguageScreenCupertino extends StatefulWidget {
  const SettingsLanguageScreenCupertino({super.key});

  @override
  State<SettingsLanguageScreenCupertino> createState() => _SettingsLanguageScreenCupertino();
}

class _SettingsLanguageScreenCupertino extends State<SettingsLanguageScreenCupertino> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemGroupedBackground,
        darkColor: CupertinoColors.darkBackgroundGray,
      ),
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.language),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Text("ddd"),
          ),
        ),
      ),
    );
  }
}
