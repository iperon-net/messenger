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
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CupertinoFormSection(
                            header: Text(context.t.myPersonalInfo),
                            children: [
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.person),
                                title: Text(context.t.myProfile),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                                ),
                              ),
                            ],
                          ),
                          CupertinoFormSection(
                            children: [
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.book),
                                title: Text(context.t.favorites),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                                ),
                              ),
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.circle_lefthalf_fill),
                                title: Text(context.t.appearance),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                                ),
                              ),
                              CupertinoListTile(
                                leading: Icon(CupertinoIcons.globe),
                                title: Text(context.t.language),
                                additionalInfo: Text("English"),
                                trailing: Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                                ),
                              ),
                            ],
                          ),
                          CupertinoFormSection(
                            children: [
                              CupertinoListTile(
                                title: Text(context.t.versionApplication),
                                additionalInfo: Text("0.0.1"),
                              ),
                            ]
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          default:
            return Container();
        }
      },
    );
  }

}
