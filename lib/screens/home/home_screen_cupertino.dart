import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/home/home_cubit.dart';

import '../../components/widget_wrapper/widget_wrapper.dart';
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

  String get restorationId => 'scroll_view';

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CupertinoTabScaffold(
            restorationId: restorationId,
            tabBar: CupertinoTabBar(
              onTap: (int index) => context.read<HomeCubit>().setCupertinoTabIndex(index),
              currentIndex: state.cupertinoTabIndex,
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
                    builder: (context) => Container(),
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
        },
      ),
    );
  }

}
