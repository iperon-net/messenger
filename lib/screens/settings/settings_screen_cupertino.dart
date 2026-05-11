import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../widgets/widgets.dart';

class SettingsCupertinoScreen extends StatefulWidget {
  const SettingsCupertinoScreen({super.key});

  @override
  State<SettingsCupertinoScreen> createState() => _SettingsCupertinoScreen();
}

class _SettingsCupertinoScreen extends State<SettingsCupertinoScreen> {
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

  void listTile() {

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.settings),
      ),
      child: Text("dddd"),
    );
  }
}

// Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10.0),
//     color: Theme.of(context).cardColor,
//   ),
//   child: ListTile(
//     leading: Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: FaIcon(FontAwesomeIcons.user, size: 18, color: Colors.white),
//       ),
//     ),
//     title: Text("Аккаунт"),
//     subtitle: Text("Информация о пользователе"),
//   ),
// ),
