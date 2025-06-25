import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_screen.dart';

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
            label: context.t.contacts,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: context.t.chats,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            // icon: Badge(label: Text('!'), child: const Icon(CupertinoIcons.settings)),
            label: context.t.settings,
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                final height = MediaQuery.of(context).size.width - 20;
                final width = MediaQuery.of(context).size.width - 20;

                return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text(context.t.contacts),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                CupertinoSearchTextField(placeholder: context.t.search),
                              ],
                            ),
                          ),
                          CupertinoFormSection(
                            header: Text(t.favorite_contacts),
                            children: [
                              CupertinoContextMenu(
                                actions: [
                                  CupertinoContextMenuAction(
                                    onPressed: () {},
                                    trailingIcon: CupertinoIcons.share,
                                    child: const Text("Share"),
                                  ),
                                ],
                                child: CupertinoListTile(
                                  leading: AvatarPlus("Алиса Тен", height: height, width: width),
                                  title: Text("Алиса Тен", style: TextStyle(fontSize: 15),),
                                  subtitle: Text(t.last_seen_minutes(n: 21)),
                                ),
                              ),
                            ],
                          ),
                          CupertinoFormSection(
                            children: [
                              CupertinoListTile(
                                leading: AvatarPlus("Костя", height: height, width: width),
                                title: Text("Костя", style: TextStyle(fontSize: 15),),
                                subtitle: Text(t.online),
                              ),
                              CupertinoListTile(
                                leading: AvatarPlus("Алиса Тен", height: height, width: width),
                                title: Text("Алиса Тен", style: TextStyle(fontSize: 15),),
                                subtitle: Text("был(а) недавно"),
                              ),
                              CupertinoListTile(
                                leading: AvatarPlus("Ирина Герасимова", height: height, width: width),
                                title: Text("Ирина Герасимова", style: TextStyle(fontSize: 15),),
                                subtitle: Text("был(а) 6 минут назад"),
                              ),
                              CupertinoListTile(
                                leading: AvatarPlus("Тен Лариса", height: height, width: width),
                                title: Text("Тен Лариса", style: TextStyle(fontSize: 15),),
                                subtitle: Text("был(а) 20.06.2025"),
                              ),
                              CupertinoListTile(
                                leading: AvatarPlus("Тен Клим", height: height, width: width),
                                title: Text("Тен Клим", style: TextStyle(fontSize: 15),),
                                subtitle: Text("был(а) 01.05.2025"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              },
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
