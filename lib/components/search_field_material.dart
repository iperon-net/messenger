import 'package:material_ui/material_ui.dart';

/// Компактное поле поиска (Android) для вкладок «Контакты», «Звонки», «Чаты»:
/// высота 40, тональная заливка без контура, скругление 12 — в стиле
/// табов-папок чатов.
class SearchFieldMaterial extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchFieldMaterial({super.key, required this.controller, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
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
  }
}
