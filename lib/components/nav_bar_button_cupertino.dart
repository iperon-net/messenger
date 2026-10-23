import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hugeicons/hugeicons.dart';

import '../i18n/translations.g.dart';
import '../themes/cupertino.dart';

/// Что делает кнопка навбара — от этого зависят значок и подпись по умолчанию.
enum NavBarAction {
  /// Подтвердить: «Готово», «Сохранить», «Создать», «Добавить» — галочка.
  done,

  /// Следующий шаг («Далее») — стрелка.
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

  /// Значок прижат к краю навбара, как был прижат текст: «Отмена»/«Закрыть»
  /// по умолчанию стоят слева (`leading`) — к левому краю, остальные справа.
  /// Если кнопка стоит не на своей стороне, сторону задают явно.
  final AlignmentGeometry? alignment;

  const NavBarButtonCupertino(this.action, {required this.onPressed, this.label, this.loading = false, this.alignment, super.key})
    : assert(label != null || (action != NavBarAction.clear && action != NavBarAction.more), 'label is required for clear/more');

  String _defaultLabel(Translations t) => switch (action) {
    NavBarAction.done => t.common.done,
    NavBarAction.next => t.common.kContinue,
    NavBarAction.cancel => t.common.cancel,
    NavBarAction.close => t.common.close,
    NavBarAction.edit => t.common.edit,
    // Своей общей подписи нет — передаётся [label].
    NavBarAction.clear || NavBarAction.more => '',
  };

  @override
  Widget build(BuildContext context) {
    if (loading) return const CupertinoActivityIndicator();

    final color = onPressed != null ? ThemesCupertino.navActionColor(context) : CupertinoColors.tertiaryLabel.resolveFrom(context);
    final icon = switch (action) {
      NavBarAction.done => Icon(CupertinoIcons.checkmark_alt, size: 26, color: color),
      NavBarAction.next => Icon(CupertinoIcons.arrow_right, size: 24, color: color),
      NavBarAction.edit => HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02, color: color, size: 22),
      NavBarAction.clear => Icon(CupertinoIcons.trash, size: 22, color: color),
      NavBarAction.more => Icon(CupertinoIcons.ellipsis_circle, size: 24, color: color),
      NavBarAction.cancel || NavBarAction.close => Icon(CupertinoIcons.xmark, size: 20, color: color),
    };
    final leading = action == NavBarAction.cancel || action == NavBarAction.close;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      alignment: alignment ?? (leading ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd),
      onPressed: onPressed,
      child: Semantics(label: label ?? _defaultLabel(context.t), child: icon),
    );
  }
}
