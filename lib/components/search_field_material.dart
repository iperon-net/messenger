import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../platform.dart';

/// Компактное поле поиска (Android) для вкладок «Контакты», «Звонки», «Чаты»:
/// высота 40, тональная заливка без контура, скругление 12 — в стиле
/// табов-папок чатов. На десктопе Esc очищает запрос, в пустом — снимает
/// фокус (как в Telegram Desktop).
class SearchFieldMaterial extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const SearchFieldMaterial({super.key, required this.controller, required this.hintText, this.onChanged, this.focusNode});

  void _escape() {
    if (controller.text.isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    }
    controller.clear();
    onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 20),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
    if (!AppPlatform.isDesktop) return field;
    return CallbackShortcuts(bindings: {const SingleActivator(LogicalKeyboardKey.escape): _escape}, child: field);
  }
}
