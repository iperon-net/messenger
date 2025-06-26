import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';

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
  Widget build(BuildContext context) {
    final _choiceTypes = <int, Widget>{
      1: Text('Все контакты'),
      2: Text('Избранные'),
      // 3: Text('3'),
      // 4: Text('4'),
      // 5: Text('5'),
      // 6: Text('выаываыва6'),
      // 7: Text('выаываыва6'),
      // 8: Text('выаываыва6'),
      // 9: Text('выаываыва6'),
      // 10: Text('выаываыва10'),
    };

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.t.contacts),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CupertinoSearchTextField(placeholder: context.t.search),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoTheme.of(context).primaryColor,
                                      width: 2.5,
                                    ),
                                  ),
                                ), //             <--- BoxDecoration here
                                child: Text(
                                  "Все контакты",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(child: Center(child: Text("Избранные", style: TextStyle(fontSize: 15),)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(child: Center(child: Text("Рабочие контакты", style: TextStyle(fontSize: 15),)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(child: Center(child: Text("Моя семья", style: TextStyle(fontSize: 15),)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(child: Center(child: Text("Заблокированные", style: TextStyle(fontSize: 15),)),),
                      ),
                    ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoFormSection(
                  children: [
                    CupertinoListTile(
                      leading: AvatarPlus("Костя", height: 32, width: 32),
                      title: Text("Костя", style: TextStyle(fontSize: 15),),
                      subtitle: Text(t.online),
                    ),
                    CupertinoListTile(
                      leading: AvatarPlus("Алиса Тен", height: 32, width: 32),
                      title: Text("Алиса Тен", style: TextStyle(fontSize: 15),),
                      subtitle: Text("был(а) недавно"),
                    ),
                    CupertinoListTile(
                      leading: AvatarPlus("Ирина Герасимова", height: 32, width: 32),
                      title: Text("Ирина Герасимова", style: TextStyle(fontSize: 15),),
                      subtitle: Text("был(а) 6 минут назад"),
                    ),
                    CupertinoListTile(
                      leading: AvatarPlus("Тен Лариса", height: 32, width: 32),
                      title: Text("Тен Лариса", style: TextStyle(fontSize: 15),),
                      subtitle: Text("был(а) 20.06.2025"),
                    ),
                    CupertinoListTile(
                      leading: AvatarPlus("Тен Клим", height: 32, width: 32),
                      title: Text("Тен Клим", style: TextStyle(fontSize: 15),),
                      subtitle: Text("был(а) 01.05.2025"),
                    ),
                  ],
                ),
              ),
            ],
          ),



          // CupertinoFormSection(
          //   children: [
          //     CupertinoListTile(
          //       leading: AvatarPlus("Костя", height: height, width: width),
          //       title: Text("Костя", style: TextStyle(fontSize: 15),),
          //       subtitle: Text(t.online),
          //     ),
          //     CupertinoListTile(
          //       leading: AvatarPlus("Алиса Тен", height: height, width: width),
          //       title: Text("Алиса Тен", style: TextStyle(fontSize: 15),),
          //       subtitle: Text("был(а) недавно"),
          //     ),
          //     CupertinoListTile(
          //       leading: AvatarPlus("Ирина Герасимова", height: height, width: width),
          //       title: Text("Ирина Герасимова", style: TextStyle(fontSize: 15),),
          //       subtitle: Text("был(а) 6 минут назад"),
          //     ),
          //     CupertinoListTile(
          //       leading: AvatarPlus("Тен Лариса", height: height, width: width),
          //       title: Text("Тен Лариса", style: TextStyle(fontSize: 15),),
          //       subtitle: Text("был(а) 20.06.2025"),
          //     ),
          //     CupertinoListTile(
          //       leading: AvatarPlus("Тен Клим", height: height, width: width),
          //       title: Text("Тен Клим", style: TextStyle(fontSize: 15),),
          //       subtitle: Text("был(а) 01.05.2025"),
          //     ),
          //   ],
          // ),
          // ],
          // ),
        ),
      ),
    );
  }

}
