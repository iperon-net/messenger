import 'package:flutter/cupertino.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../contacts/contacts_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreenCupertino extends StatefulWidget {
  const HomeScreenCupertino({super.key});

  @override
  State<HomeScreenCupertino> createState() => _HomeScreenCupertino();
}

class _HomeScreenCupertino extends State<HomeScreenCupertino> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: context.t.contacts.contacts,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: context.t.chats.chats,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            // icon: Badge(label: Text('!'), child: const Icon(CupertinoIcons.settings)),
            label: context.t.settings.settings,
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const ContactsScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return Container();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const SettingsScreen(),
            );
          default:
            return Container();
        }
      },
    );
  }

}
