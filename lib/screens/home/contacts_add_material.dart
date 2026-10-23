import 'package:material_ui/material_ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

/// Полноэкранная форма добавления контакта по номеру (имя, фамилия, телефон с
/// форматированием). Экран не имеет доступа к [ContactsCubit] (он живёт на уровне
/// shell, а этот экран пушится на root-навигаторе), поэтому по «Добавить» просто
/// возвращает [ContactAddInput] через pop — вызов cubit делает список контактов.
///
/// Та же форма — правка контакта из профиля пользователя ([edit]): поля
/// заполнены [initial], номер не меняется, [removable] — внизу «Удалить
/// контакт» (pop с `remove: true`).
class ContactsAddMaterial extends StatefulWidget {
  final ContactAddInput? initial;
  final bool edit;
  final bool removable;

  const ContactsAddMaterial({super.key, this.initial, this.edit = false, this.removable = false});

  @override
  State<ContactsAddMaterial> createState() => _ContactsAddMaterialState();
}

class _ContactsAddMaterialState extends State<ContactsAddMaterial> {
  late final _firstNameController = TextEditingController(text: widget.initial?.firstName);
  final _firstNameFocus = FocusNode();
  late final _lastNameController = TextEditingController(text: widget.initial?.lastName);
  final _lastNameFocus = FocusNode();
  late final _phoneController = TextEditingController(text: widget.initial?.phone);
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
    // Navigator, а не go_router: из профиля форма открывается императивно.
    Navigator.of(
      context,
    ).pop(ContactAddInput(firstName: _firstNameController.text.trim(), lastName: _lastNameController.text.trim(), phone: phone));
  }

  Future<void> _remove() async {
    final t = context.t.screenContacts;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.removeTitle),
        content: Text(t.removeMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.remove),
          ),
        ],
      ),
    );
    if ((confirmed ?? false) && mounted) {
      Navigator.of(context).pop(const ContactAddInput(firstName: '', lastName: '', phone: '', remove: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenContacts;

    // Единый стиль полей ввода с экраном правки профиля: без рамки, чтобы жить
    // внутри белого блока (Card) сгруппированным списком.
    InputDecoration decoration({required String label, String? hint}) => InputDecoration(
      labelText: label,
      hintText: hint,
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

    // autofillHints: null — именно null: по умолчанию у поля пустой список, и
    // оно всё равно участвует в автозаполнении Android. Система угадывает поле
    // имени и открывает поверх приложения окно с подсказкой, оно забирает фокус
    // окна — и клавиатура закрывалась после первой буквы.
    final firstNameField = TextFormField(
      controller: _firstNameController,
      focusNode: _firstNameFocus,
      autofocus: LocaleSettings.currentLocale == AppLocale.en ? true : false,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: null,
      decoration: decoration(label: t.addFirstName),
    );
    final lastNameField = TextFormField(
      controller: _lastNameController,
      focusNode: _lastNameFocus,
      autofocus: LocaleSettings.currentLocale == AppLocale.en ? false : true,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: null,
      decoration: decoration(label: t.addLastName),
    );
    // Для русской локали фамилия выше имени, в остальных — имя, затем фамилия.
    final nameFields = LocaleSettings.currentLocale == AppLocale.ru ? [lastNameField, firstNameField] : [firstNameField, lastNameField];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? t.editContact : t.addContact),
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
                      // Номер — адрес контакта: при правке не меняется.
                      enabled: !widget.edit,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [PhoneInputFormatter()],
                      decoration: decoration(label: t.addByNumberHint),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                ],
              ),
            ),
            // Grouped-style подпись: добавленный вручную контакт — облачный,
            // синхронизируется между устройствами владельца.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(t.addSyncHint, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
            if (widget.removable)
              Card(
                margin: const EdgeInsets.only(top: 16),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  title: Text(t.removeContact, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  onTap: _remove,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
