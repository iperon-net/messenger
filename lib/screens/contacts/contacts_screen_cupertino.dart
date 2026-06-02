import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/translations.g.dart';

class ContactsScreenCupertino extends StatefulWidget {
  const ContactsScreenCupertino({super.key});

  @override
  State<ContactsScreenCupertino> createState() => _ContactsScreenCupertino();
}

class _ContactsScreenCupertino extends State<ContactsScreenCupertino> {
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
        middle: Text(context.t.contacts),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: ListView(
              children: [
              ],
            ),
          ),
        ),
      ),
    );

  }
}
