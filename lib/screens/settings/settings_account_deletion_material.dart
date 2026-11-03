import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsAccountDeletionMaterial extends StatefulWidget {
  const SettingsAccountDeletionMaterial({super.key});
  @override
  State<SettingsAccountDeletionMaterial> createState() => _SettingsAccountDeletionMaterialState();
}

class _SettingsAccountDeletionMaterialState extends State<SettingsAccountDeletionMaterial> {
  final phone = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  void _error() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.accountDeletion.requestError)));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountDeletionCubit()..load(),
      child: BlocBuilder<AccountDeletionCubit, AccountDeletionState>(
        builder: (context, state) {
          final scheduled = state.manualDeleteAfter;
          return Scaffold(
            appBar: AppBar(title: Text(context.t.accountDeletion.title)),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(context.t.accountDeletion.warning),
                const SizedBox(height: 24),
                if (scheduled != null) ...[
                  Text(context.t.accountDeletion.scheduled(date: scheduled.toLocal().toString())),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                    onPressed: state.loading
                        ? null
                        : () async {
                            if (!await context.read<AccountDeletionCubit>().cancel()) _error();
                          },
                    child: Text(context.t.accountDeletion.cancel),
                  ),
                ] else ...[
                  TextField(
                    key: ObjectKey(phone),
                    controller: phone,
                    decoration: InputDecoration(
                      labelText: context.t.accountDeletion.phonePlaceholder,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: ObjectKey(password),
                    controller: password,
                    decoration: InputDecoration(
                      labelText: context.t.accountDeletion.passwordPlaceholder,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    obscureText: true,
                    autofillHints: null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                    onPressed: state.loading
                        ? null
                        : () async {
                            if (!await context.read<AccountDeletionCubit>().request(phone.text, password.text)) _error();
                          },
                    child: Text(context.t.accountDeletion.confirm),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
