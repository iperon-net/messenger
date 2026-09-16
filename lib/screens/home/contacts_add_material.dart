import 'package:material_ui/material_ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(t.addByNumber),
        actions: [TextButton(onPressed: _submit, child: Text(t.add))],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _firstNameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: t.addFirstName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: t.addLastName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneInputFormatter()],
              decoration: InputDecoration(labelText: t.addByNumberHint, prefixIcon: const Icon(Icons.phone)),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
