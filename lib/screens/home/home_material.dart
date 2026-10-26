import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../settings/settings_accounts_material.dart';

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
    // Ширина панели вкладок = ширина списка, а её на десктопе тянут мышью.
    return ValueListenableBuilder(valueListenable: SplitLayout.listWidthOverride, builder: (context, _, _) => _build(context));
  }

  Widget _build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        // Планшет, широкое окно: панель вкладок только под левой колонкой
        // (списком), как в Telegram, — правая панель идёт до низа экрана. Отступ
        // под панель списку добавляет SplitViewMaterial.
        final wide = SplitLayout.isWide(context);
        final barWidth = wide ? SplitLayout.listWidth(MediaQuery.sizeOf(context).width) : MediaQuery.sizeOf(context).width;
        // Долгий тап по «Настройкам» — быстрый выбор аккаунта (как в
        // Telegram); обычный тап проходит к панели.
        final bar = Stack(
          children: [
            NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, size: 24.0, strokeWidth: 2),
                  selectedIcon: const HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, size: 24.0, strokeWidth: 2),
                  label: context.t.screenHome.contacts,
                ),
                NavigationDestination(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedCall02, size: 24.0, strokeWidth: 2),
                  selectedIcon: const HugeIcon(icon: HugeIcons.strokeRoundedCall02, size: 24.0, strokeWidth: 2),
                  label: context.t.screenHome.calls,
                ),
                NavigationDestination(icon: const _ChatsIcon(), selectedIcon: const _ChatsIcon(), label: context.t.screenHome.chats),
                NavigationDestination(
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedSettings01, size: 24.0, strokeWidth: 2),
                  selectedIcon: const HugeIcon(icon: HugeIcons.strokeRoundedSettings01, size: 24.0, strokeWidth: 2),
                  label: context.t.screenHome.settings,
                  // Подсказку по долгому тапу заменяет выбор аккаунта.
                  tooltip: '',
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: barWidth / 4,
              child: GestureDetector(behavior: HitTestBehavior.translucent, onLongPress: () => showAccountSwitcherMaterial(context)),
            ),
          ],
        );
        if (!wide) return Scaffold(body: widget.navigationShell, bottomNavigationBar: bar);
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: widget.navigationShell),
              Positioned(left: 0, bottom: 0, width: barWidth, child: bar),
            ],
          ),
        );
      },
    );
  }
}

/// Иконка вкладки «Чаты» со счётчиком непрочитанных чатов (без заглушённых) —
/// как в Telegram.
class _ChatsIcon extends StatelessWidget {
  const _ChatsIcon();

  @override
  Widget build(BuildContext context) => UnreadTotalBuilder(
    builder: (context, total) => Badge(
      isLabelVisible: total > 0,
      label: Text(ChatTileContent.badge(total)),
      child: const HugeIcon(icon: HugeIcons.strokeRoundedChatFeedback01, size: 24.0, strokeWidth: 2),
    ),
  );
}
