import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

class HomeScreenMaterial extends StatefulWidget {
  const HomeScreenMaterial({super.key});

  @override
  State<HomeScreenMaterial> createState() => _HomeScreenMaterial();
}

class _HomeScreenMaterial extends State<HomeScreenMaterial> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final logger = getIt.get<Logger>();
    logger.debug("dddd");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: Text(""),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        width: 350,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white54,
                child: const Text('KO'),
              ),
              accountName: Container(),
              accountEmail: Text("kostya@yandex.ru"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(context.t.contacts),
            ),
            ListTile(
              leading: Icon(Icons.bookmark_border_outlined),
              title: Text(context.t.favorites),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(context.t.settings),
              onTap: () {
                if (_scaffoldKey.currentState?.isDrawerOpen == true) _scaffoldKey.currentState?.closeDrawer();
                context.goNamed("settings");
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
            children: [
              Text("dddd"),
            ],
          )
      ),
    );
  }

}
