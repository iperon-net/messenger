import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';

class HomeMaterial extends StatefulWidget {
  const HomeMaterial({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeMaterial> createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State<HomeMaterial> {
  // Счётчик быстрых тапов по вкладке «Настройки» для открытия скрытого экрана
  // «Разработчик» (5 тапов подряд). Сбрасывается при паузе или тапе по другой
  // вкладке. См. [_onTap].
  int _settingsTaps = 0;
  DateTime? _lastSettingsTap;

  void _onTap(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
    _maybeOpenDeveloper(index);
  }

  // 5 тапов подряд (с паузами ≤ 2 c) по вкладке «Настройки» открывают скрытый
  // экран «Разработчик». Тап по любой другой вкладке сбрасывает счётчик.
  void _maybeOpenDeveloper(int index) {
    const settingsIndex = 3;
    if (index != settingsIndex) {
      _settingsTaps = 0;
      return;
    }
    final now = DateTime.now();
    if (_lastSettingsTap == null || now.difference(_lastSettingsTap!) > const Duration(seconds: 2)) {
      _settingsTaps = 0;
    }
    _lastSettingsTap = now;
    _settingsTaps++;
    if (_settingsTaps >= 5) {
      _settingsTaps = 0;
      context.go("/settings/developer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const FaIcon(FontAwesomeIcons.solidCircleUser),
                selectedIcon: const FaIcon(FontAwesomeIcons.solidCircleUser),
                label: context.t.screenHome.contacts,
              ),
              NavigationDestination(
                icon: const FaIcon(FontAwesomeIcons.phoneFlip),
                selectedIcon: const FaIcon(FontAwesomeIcons.phoneFlip),
                label: context.t.screenHome.calls,
              ),
              NavigationDestination(
                icon: const FaIcon(FontAwesomeIcons.solidComments),
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
