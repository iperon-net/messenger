import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/syncer.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../screens.dart';

class HomeCupertinoScreen extends StatefulWidget {
  const HomeCupertinoScreen({super.key});

  @override
  State<HomeCupertinoScreen> createState() => _HomeCupertinoScreen();
}

class _HomeCupertinoScreen extends State<HomeCupertinoScreen> {
  final logger = getIt.get<Logger>();
  final syncer = getIt.get<Syncer>();

  final formKey = GlobalKey<FormState>();
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    syncer.connect();

    _lifecycleListener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        logger.debug("AppLifecycleListener state = $state");

        if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
          syncer.dispose();
        } else if (state == AppLifecycleState.resumed && mounted) {
          syncer.connect();
        }
      },
    );
    logger.debug("initState");
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    syncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 2,
        height: 56,
        iconSize: 24,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(''),
              badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.red,
                elevation: 1,
              ),
              child: FaIcon(FontAwesomeIcons.solidCircleUser),
            ),
            label: context.t.contacts,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.phoneFlip),
            label: context.t.calls,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidComments),
            label: context.t.chats,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: context.t.settings,
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 0) {
              return ContactsScreenCupertino();
            } else if (index == 3) {
              return SettingsCupertinoScreen();
            }
            return Center(child: Text("Page not found"));
          },
        );
        },
    );
  }

}
