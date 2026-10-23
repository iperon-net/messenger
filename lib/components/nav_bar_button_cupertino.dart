import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../cubit.dart';
import '../i18n/translations.g.dart';
import '../themes/cupertino.dart';

/// Что делает кнопка навбара — от этого зависят значок и подпись по умолчанию.
enum NavBarAction {
  /// Подтвердить: «Готово», «Сохранить», «Создать», «Добавить» — галочка в
  /// круге с заливкой акцентом (как в iOS 26).
  done,

  /// Следующий шаг («Далее») — стрелка в таком же круге.
  next,

  /// «Отмена» — крестик.
  cancel,

  /// «Закрыть» — крестик.
  close,

  /// «Изменить» — карандаш.
  edit,

  /// «Очистить» — корзина.
  clear,

  /// Открыть меню («Все» и т. п.) — многоточие в круге.
  more,
}

/// Кнопка-значок в `leading`/`trailing` навбара и в шапках модальных листов
/// вместо текстовых «Сохранить», «Изменить», «Отмена»… Подпись не рисуется, но
/// остаётся для VoiceOver ([label], по умолчанию — по [action]).
///
/// Цвета вшиты в сам значок, а не берутся из [AppCupertinoNavigationBar]: при
/// hero-переходе навбара кнопки переносятся в overlay и теряют его локальную
/// тему (см. [ThemesCupertino.navActionColor]).
class NavBarButtonCupertino extends StatelessWidget {
  final NavBarAction action;
  final VoidCallback? onPressed;
  final String? label;

  /// Запрос в процессе — вместо кнопки крутилка (как было у текстовых).
  final bool loading;

  const NavBarButtonCupertino(this.action, {required this.onPressed, this.label, this.loading = false, super.key})
    : assert(label != null || (action != NavBarAction.clear && action != NavBarAction.more), 'label is required for clear/more');

  bool get _prominent => action == NavBarAction.done || action == NavBarAction.next;

  String _defaultLabel(Translations t) => switch (action) {
    NavBarAction.done => t.common.done,
    NavBarAction.next => t.common.kContinue,
    NavBarAction.cancel => t.common.cancel,
    NavBarAction.close => t.common.close,
    NavBarAction.edit => t.common.edit,
    // Своей общей подписи нет — передаётся [label].
    NavBarAction.clear || NavBarAction.more => '',
  };

  /// Базовый цвет оформления. Внутри [AppCupertinoNavigationBar] `primaryColor`
  /// в тёмной теме подменён на белый, поэтому заливку строим из настроек, так
  /// же как тема в `app_cupertino.dart` (на /auth — всегда синий).
  CupertinoDynamicColor _base(BuildContext context) {
    final state = context.watch<CommonCubit>().state;
    return state.isAuthRoute ? ThemesCupertino().blueScheme : ThemesCupertino.base(state.settingsDevice.colorTheme);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CupertinoActivityIndicator();

    final enabled = onPressed != null;
    final Widget icon;
    if (_prominent) {
      final base = _base(context);
      final fill = enabled ? ThemesCupertino.accent(base).resolveFrom(context) : CupertinoColors.tertiarySystemFill.resolveFrom(context);
      final foreground = enabled
          ? ThemesCupertino.accentContrasting(base).resolveFrom(context)
          : CupertinoColors.tertiaryLabel.resolveFrom(context);
      icon = Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(action == NavBarAction.done ? CupertinoIcons.checkmark_alt : CupertinoIcons.arrow_right, size: 20, color: foreground),
      );
    } else {
      final color = enabled ? ThemesCupertino.navActionColor(context) : CupertinoColors.tertiaryLabel.resolveFrom(context);
      icon = switch (action) {
        NavBarAction.edit => HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02, color: color, size: 22),
        NavBarAction.clear => Icon(CupertinoIcons.trash, size: 22, color: color),
        NavBarAction.more => Icon(CupertinoIcons.ellipsis_circle, size: 24, color: color),
        _ => Icon(CupertinoIcons.xmark, size: 20, color: color),
      };
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: onPressed,
      child: Semantics(label: label ?? _defaultLabel(context.t), child: icon),
    );
  }
}
