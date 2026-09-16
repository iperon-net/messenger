import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../themes.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';

/// Полноэкранная форма добавления контакта по номеру (имя, фамилия, телефон с
/// форматированием). Экран не имеет доступа к [ContactsCubit] (он живёт на уровне
/// shell, а этот экран пушится на root-навигаторе), поэтому по «Добавить» просто
/// возвращает [ContactAddInput] через pop — вызов cubit делает список контактов.
class ContactsAddCupertino extends StatefulWidget {
  const ContactsAddCupertino({super.key});

  @override
  State<ContactsAddCupertino> createState() => _ContactsAddCupertinoState();
}

class _ContactsAddCupertinoState extends State<ContactsAddCupertino> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

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
    context.pop(ContactAddInput(firstName: _firstNameController.text.trim(), lastName: _lastNameController.text.trim(), phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenContacts;

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.addByNumber),
          trailing: CupertinoButton(padding: EdgeInsets.zero, onPressed: _submit, child: Text(t.add)),
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
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter()],
                  placeholder: t.addByNumberHint,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
