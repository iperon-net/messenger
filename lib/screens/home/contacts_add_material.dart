import 'package:material_ui/material_ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

/// Полноэкранная форма добавления контакта по номеру (имя, фамилия, телефон с
/// форматированием). Экран не имеет доступа к [ContactsCubit] (он живёт на уровне
/// shell, а этот экран пушится на root-навигаторе), поэтому по «Добавить» просто
/// возвращает [ContactAddInput] через pop — вызов cubit делает список контактов.
class ContactsAddMaterial extends StatefulWidget {
  const ContactsAddMaterial({super.key});

  @override
  State<ContactsAddMaterial> createState() => _ContactsAddMaterialState();
}

class _ContactsAddMaterialState extends State<ContactsAddMaterial> {
  final _firstNameController = TextEditingController();
  final _firstNameFocus = FocusNode();
  final _lastNameController = TextEditingController();
  final _lastNameFocus = FocusNode();
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameController.dispose();
    _lastNameFocus.dispose();
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.pop(ContactAddInput(firstName: _firstNameController.text.trim(), lastName: _lastNameController.text.trim(), phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenContacts;

    // Единый стиль полей ввода с экраном правки профиля: без рамки, чтобы жить
    // внутри белого блока (Card) сгруппированным списком.
    InputDecoration decoration({required String label, String? hint, Widget? prefixIcon}) => InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      // Label всегда сверху: поля пустые (в отличие от правки профиля, где они
      // заполнены), поэтому иначе label «улетает» вверх при фокусе.
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // Убираем рамку во всех состояниях: глобальная тема (inputDecorationTheme)
      // задаёт OutlineInputBorder для enabled/focused, поэтому одного border мало.
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      // Подтягиваем текст ошибки ближе к полю (без рамки дефолтный зазор смотрится оторванным).
      errorStyle: const TextStyle(height: 0.8),
    );

    final firstNameField = TextFormField(
      controller: _firstNameController,
      focusNode: _firstNameFocus,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.givenName],
      decoration: decoration(label: t.addFirstName),
    );
    final lastNameField = TextFormField(
      controller: _lastNameController,
      focusNode: _lastNameFocus,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.familyName],
      decoration: decoration(label: t.addLastName),
    );
    // Для русской локали фамилия выше имени, в остальных — имя, затем фамилия.
    final nameFields = LocaleSettings.currentLocale == AppLocale.ru ? [lastNameField, firstNameField] : [firstNameField, lastNameField];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.addContact),
        actions: [
          TextButton(
            onPressed: _submit,
            child: FaIcon(FontAwesomeIcons.check, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: nameFields[0]),
                  const Divider(height: .3, color: Colors.black12),
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: nameFields[1]),
                  const Divider(height: .3, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [PhoneInputFormatter()],
                      decoration: decoration(label: t.addByNumberHint, prefixIcon: const Icon(Icons.phone)),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
