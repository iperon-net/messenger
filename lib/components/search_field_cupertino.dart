import 'package:cupertino_ui/cupertino_ui.dart';

/// Компактное поле поиска (iOS) для вкладок «Контакты», «Звонки», «Чаты»:
/// ~32 pt вместо системных 36 (меньше отступы, шрифт и лупа) — вровень с
/// сегмент-контролом «Звонков» и табами-папками чатов.
class SearchFieldCupertino extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const SearchFieldCupertino({super.key, required this.controller, required this.placeholder, this.onChanged, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      padding: const EdgeInsetsDirectional.fromSTEB(5.5, 7, 5.5, 7),
      itemSize: 16,
      prefixInsets: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
      style: TextStyle(fontSize: 15, color: CupertinoColors.label.resolveFrom(context)),
      onChanged: onChanged,
    );
  }
}
