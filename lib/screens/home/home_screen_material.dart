import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import 'home_cubit.dart';

class HomeScreenMaterial extends StatefulWidget {
  const HomeScreenMaterial({super.key});

  @override
  State<HomeScreenMaterial> createState() => _HomeScreenMaterial();
}

class _HomeScreenMaterial extends State<HomeScreenMaterial> {

  @override
  void initState() {
    context.read<HomeCubit>().initialization();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // if (state.notificationPermissionStatus.isPermanentlyDenied){
        //   showModalBottomSheet(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return SizedBox(
        //         height: 200,
        //         child: Card(
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const ListTile(
        //                 leading: Icon(Icons.notifications),
        //                 title: Text('Уведомления'),
        //                 subtitle: Text('Включите уведомления чтобы не пропустить важное событие'),
        //               ),
        //               const SizedBox(height: 50),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   TextButton(
        //                     child: const Text('Включить'),
        //                     onPressed: () {},
        //                   ),
        //                   const SizedBox(width: 30),
        //                   TextButton(
        //                     child: const Text('Не сейчас'),
        //                     onPressed: () {},
        //                   ),
        //                   const SizedBox(width: 8),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   );
        // }
      },
      builder: (context, state) {
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
                      color: Theme
                          .of(context)
                          .appBarTheme
                          .backgroundColor
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
                  title: Text(context.t.drawer.contacts),
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_border_outlined),
                  title: Text(context.t.drawer.favorites),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(context.t.settings.settings),
                  onTap: () {
                    if (_scaffoldKey.currentState?.isDrawerOpen == true) _scaffoldKey.currentState?.closeDrawer();
                    context.goNamed("settings");
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
              top: false,
              bottom: false,
              child: Center(child: ClipRRect(child: Text("fasdfasdfasdfasfasd")),)
          ),
        );
      },
    );
  }

}
