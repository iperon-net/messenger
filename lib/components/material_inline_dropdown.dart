import 'package:material_ui/material_ui.dart';

import '../themes.dart';

/// Инлайн-дропдаун для строки настроек (Material): текущее значение + стрелка
/// справа от заголовка плитки; тап открывает `PopupMenuButton` с вариантами.
///
/// Используется как `trailing` у [MaterialListTileIcon]/`ListTile` — см.
/// экраны «Конфиденциальность» (выбор аудитории звонков) и «Код-пароль»
/// (автоблокировка). Значение подписи берётся из [AppFontSizes] темы.
class MaterialInlineDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  const MaterialInlineDropdown({required this.value, required this.items, required this.labelBuilder, required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final item in items) CheckedPopupMenuItem<T>(value: item, checked: item == value, child: Text(labelBuilder(item))),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelBuilder(value),
            style: TextStyle(fontSize: AppFontSizes.listTitle, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const Icon(Icons.arrow_drop_down, size: 26),
        ],
      ),
    );
  }
}
