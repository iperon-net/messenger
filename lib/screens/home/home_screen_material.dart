import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';

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
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Iperon",
        ),
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
        width: 340,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white60,
                child: const Text('КО'),
              ),
              accountName: Text(
                "Костя",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
              accountEmail: Text(
                "+999 100 000 00 00",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
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
      body: Center(child: Text("!!!"),)
    );
  }

}
