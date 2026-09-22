import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../themes.dart';

class HomeCupertino extends StatefulWidget {
  const HomeCupertino({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeCupertino> createState() => _HomeCupertinoState();
}

class _HomeCupertinoState extends State<HomeCupertino> {
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
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        const double tabBarHeight = 58;
        final double bottomInset = MediaQuery.of(context).padding.bottom;

        final tabBar = CupertinoTabBar(
          backgroundColor: ThemesCupertino.tabBarBackground.resolveFrom(context),
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onTap,
          height: tabBarHeight,
          iconSize: 24,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, size: 24.0, strokeWidth: 2),
                // child: badges.Badge(
                //   badgeContent: Text(''),
                //   badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                //   // badgeStyle: badges.BadgeStyle(badgeColor: Colors.red, elevation: 1),
                //   child: HugeIcon(
                //     icon: HugeIcons.strokeRoundedUserCircle,
                //     size: 24.0,
                //     strokeWidth: 2,
                //   ),
                // ),
              ),
              label: context.t.screenHome.contacts,
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: HugeIcon(icon: HugeIcons.strokeRoundedCall02, size: 24.0, strokeWidth: 2),
              ),
              label: context.t.screenHome.calls,
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: HugeIcon(icon: HugeIcons.strokeRoundedChatFeedback01, size: 24.0, strokeWidth: 2),
              ),
              label: context.t.screenHome.chats,
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: HugeIcon(icon: HugeIcons.strokeRoundedSettings01, size: 24.0, strokeWidth: 2),
              ),
              label: context.t.screenHome.settings,
            ),
          ],
        );

        return CupertinoPageScaffold(
          // Не поднимаем весь Stack на высоту клавиатуры — иначе таб-бар
          // (Positioned bottom:0) всплывает над клавиатурой и перекрывает нижние
          // результаты. Так таб-бар остаётся у физического низа (за клавиатурой),
          // а viewInsets доходят до navigationShell, и внутренний экран сам ужимает
          // свой контент над клавиатурой.
          resizeToAvoidBottomInset: false,
          child: Stack(
            children: [
              // Контент занимает всю высоту (в т.ч. под баром), а нижний отступ
              // равный высоте бара пробрасываем через MediaQuery — так последний
              // элемент списка доступен, а сам список уходит под полупрозрачный
              // таб-бар вместо зазора над ним.
              Positioned.fill(
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(padding: MediaQuery.of(context).padding.copyWith(bottom: tabBarHeight + bottomInset)),
                  child: widget.navigationShell,
                ),
              ),
              Positioned(left: 0, right: 0, bottom: 0, child: tabBar),
            ],
          ),
        );
      },
    );
  }
}
