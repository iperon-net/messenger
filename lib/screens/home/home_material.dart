import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';

class HomeMaterial extends StatelessWidget {
  const HomeMaterial({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const FaIcon(FontAwesomeIcons.circleUser),
                selectedIcon: const FaIcon(FontAwesomeIcons.solidCircleUser),
                label: context.t.screenHome.contacts,
              ),
              NavigationDestination(icon: const FaIcon(FontAwesomeIcons.phoneFlip), label: context.t.screenHome.calls),
              NavigationDestination(
                icon: const FaIcon(FontAwesomeIcons.comments),
                selectedIcon: const FaIcon(FontAwesomeIcons.solidComments),
                label: context.t.screenHome.chats,
              ),
              NavigationDestination(icon: const FaIcon(FontAwesomeIcons.gear), label: context.t.screenHome.settings),
            ],
          ),
        );
      },
    );
  }
}
