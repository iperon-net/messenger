import 'package:flutter/cupertino.dart';
import 'package:messenger/i18n/translations.g.dart';

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
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: context.t.contacts,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: context.t.chats,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: context.t.settings,
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(

                    middle: Text(context.t.contacts),
                    // leading: Align( // https://github.com/flutter/flutter/issues/18536
                    //   widthFactor: 1.0,
                    //   alignment: Alignment.center,
                    //   child: Text('Sor'),
                    // ),
                    trailing: Icon(CupertinoIcons.add, size: 20),
                  ),
                  child: Center(
                    child: Text(context.t.contacts),
                  ),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(context.t.chats),
                  ),
                  child: Center(
                    child: Text(context.t.chats),
                  ),
                );
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(context.t.settings),
                  ),
                  child: Center(
                    child: Text(context.t.settings),
                  ),
                );
              },
            );
          default:
            return Container();
        }
      },
    );

    // return CupertinoPageScaffold(
    //   navigationBar: CupertinoNavigationBar(
    //     middle: Text('Чаты'),
    //   ),
    //   child: CupertinoTabScaffold(
    //     tabBar: CupertinoTabBar(
    //       iconSize: 25,
    //       items: [
    //         BottomNavigationBarItem(
    //           icon: Icon(CupertinoIcons.person_2_fill),
    //           label: 'Contacts',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(CupertinoIcons.chat_bubble_2_fill),
    //           label: 'Chats',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(CupertinoIcons.settings),
    //           label: 'Settings',
    //         ),
    //       ],
    //     ),
    //     tabBuilder: (BuildContext context, int index) {
    //       switch (index) {
    //         case 0:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return CupertinoPageScaffold(
    //                 child: Center(
    //                   child: Text('Home'),
    //                 ),
    //               );
    //             },
    //           );
    //         case 1:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return CupertinoPageScaffold(
    //                 child: Center(
    //                   child: Text('Search'),
    //                 ),
    //               );
    //             },
    //           );
    //         case 2:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return CupertinoPageScaffold(
    //                 child: Center(
    //                   child: Text('Profile'),
    //                 ),
    //               );
    //             },
    //           );
    //         default:
    //           return Container();
    //       }
    //     },
    //   ),
    // );
  }

}
