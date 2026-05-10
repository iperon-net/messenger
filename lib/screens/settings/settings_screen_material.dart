import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../di.dart';
import '../../logger.dart';
import '../../widgets/widgets.dart';

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

  void listTile() {

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: Text("Аккаунт", style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(18)),),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.user, size: 18, color: Colors.white),
                ),
              ),
              title: Text("Аккаунт"),
              subtitle: Text("Информация о пользователе"),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: IconFrameWidget(color: Colors.purple, icon: FaIcon(FontAwesomeIcons.paintbrush, size: 16, color: Colors.white)),
              title: Text("Оформление"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: IconFrameWidget(color: Colors.redAccent, icon: FaIcon(FontAwesomeIcons.shield, size: 16, color: Colors.white)),
              title: Text("Конфидициальность"),
              subtitle: Text("Pin-код, облачный пароль"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: IconFrameWidget(color: Colors.orange, icon: FaIcon(FontAwesomeIcons.language, size: 16, color: Colors.white)),
              title: Text("Устройства"),
              subtitle: Text("Управление активными устройствами"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: IconFrameWidget(color: Colors.green, icon: FaIcon(FontAwesomeIcons.language, size: 16, color: Colors.white)),
              title: Text("Язык"),
              subtitle: Text("Русский"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: IconFrameWidget(color: Colors.teal, icon: FaIcon(FontAwesomeIcons.circleQuestion, size: 18, color: Colors.white)),
              title: Text("Помошь"),
            ),
          ),
        ],
      ),
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
