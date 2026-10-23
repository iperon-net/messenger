import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../cubit.dart';
import '../../themes.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';

/// Полноэкранная форма добавления контакта по номеру (имя, фамилия, телефон с
/// форматированием). Экран не имеет доступа к [ContactsCubit] (он живёт на уровне
/// shell, а этот экран пушится на root-навигаторе), поэтому по «Добавить» просто
/// возвращает [ContactAddInput] через pop — вызов cubit делает список контактов.
///
/// Та же форма — правка контакта из профиля пользователя ([edit]): поля
/// заполнены [initial], номер не меняется, [removable] — внизу «Удалить
/// контакт» (pop с `remove: true`).
class ContactsAddCupertino extends StatefulWidget {
  final ContactAddInput? initial;
  final bool edit;
  final bool removable;

  const ContactsAddCupertino({super.key, this.initial, this.edit = false, this.removable = false});

  @override
  State<ContactsAddCupertino> createState() => _ContactsAddCupertinoState();
}

class _ContactsAddCupertinoState extends State<ContactsAddCupertino> {
  late final _firstNameController = TextEditingController(text: widget.initial?.firstName);
  late final _lastNameController = TextEditingController(text: widget.initial?.lastName);
  late final _phoneController = TextEditingController(text: widget.initial?.phone);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
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
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.removeTitle),
        content: Text(t.removeMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.remove)),
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

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(widget.edit ? t.editContact : t.addContact),
          trailing: NavBarButtonCupertino(NavBarAction.done, label: widget.edit ? context.t.common.done : t.add, onPressed: _submit),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            CupertinoListSection.insetGrouped(
              backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
              decoration: BoxDecoration(
                color: ThemesCupertino.groupedCard.resolveFrom(context),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              // Добавленный вручную контакт — облачный, синхронизируется между
              // устройствами владельца.
              footer: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text(t.addSyncHint, style: TextStyle(fontSize: AppFontSizes.caption)),
              ),
              children: [
                CupertinoTextFormFieldRow(
                  controller: _firstNameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  placeholder: t.addFirstName,
                ),
                CupertinoTextFormFieldRow(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  placeholder: t.addLastName,
                ),
                CupertinoTextFormFieldRow(
                  controller: _phoneController,
                  // Номер — адрес контакта: при правке не меняется.
                  enabled: !widget.edit,
                  // Без своей decoration выключенное поле залито почти чёрным в
                  // тёмной теме (см. CLAUDE.md, «Form fields — gotchas»).
                  decoration: const BoxDecoration(),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter()],
                  placeholder: t.addByNumberHint,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
            if (widget.removable)
              CupertinoListSection.insetGrouped(
                backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                decoration: BoxDecoration(
                  color: ThemesCupertino.groupedCard.resolveFrom(context),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                children: [
                  CupertinoListTile(
                    title: Text(t.removeContact, style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                    onTap: _remove,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
