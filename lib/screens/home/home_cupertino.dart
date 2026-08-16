import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';

class HomeCupertino extends StatelessWidget {
  const HomeCupertino({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          child: Column(
            children: [
              Expanded(child: navigationShell),
              CupertinoTabBar(
                currentIndex: navigationShell.currentIndex,
                onTap: _onTap,
                height: 58,
                iconSize: 24,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: badges.Badge(
                        badgeContent: Text(''),
                        badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                        badgeStyle: badges.BadgeStyle(badgeColor: Colors.red, elevation: 1),
                        child: FaIcon(FontAwesomeIcons.solidCircleUser),
                      ),
                    ),
                    label: context.t.common.contacts,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(padding: EdgeInsets.only(top: 8), child: FaIcon(FontAwesomeIcons.phoneFlip)),
                    label: context.t.common.calls,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(padding: EdgeInsets.only(top: 8), child: FaIcon(FontAwesomeIcons.solidComments)),
                    label: context.t.common.chats,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(padding: EdgeInsets.only(top: 8), child: FaIcon(FontAwesomeIcons.gear)),
                    label: context.t.common.settings,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
