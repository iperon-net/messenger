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
  final formKey = GlobalKey<FormState>();
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
          final passwordRequired = state.cloudPasswordEnabled && !state.cloudPasswordUnlocked;
          InputDecoration decoration(String label) => InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            errorStyle: const TextStyle(height: 0.8),
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(context.t.accountDeletion.title),
              actions: [
                if (state.loaded && scheduled == null && passwordRequired)
                  IconButton(
                    tooltip: context.t.common.kContinue,
                    onPressed: state.loading
                        ? null
                        : () async {
                            final cubit = context.read<AccountDeletionCubit>();
                            if (!await cubit.unlock(password.text) && cubit.state.error.isEmpty) _error();
                          },
                    icon: const Icon(Icons.check),
                  ),
              ],
            ),
            body: !state.loaded
                ? Center(
                    child: state.loading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () => context.read<AccountDeletionCubit>().load(),
                            child: Text(context.t.cloudPassword.retry),
                          ),
                  )
                : Form(
                    key: formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text(
                            scheduled == null && passwordRequired ? context.t.cloudPassword.unlockInfo : context.t.accountDeletion.warning,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (scheduled != null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(context.t.accountDeletion.scheduled(date: scheduled.toLocal().toString())),
                          ),
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
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: passwordRequired
                                  ? TextFormField(
                                      key: ObjectKey(password),
                                      controller: password,
                                      decoration: decoration(context.t.cloudPassword.passwordPlaceholder),
                                      obscureText: true,
                                      autofillHints: null,
                                      autofocus: true,
                                    )
                                  : TextFormField(
                                      key: ObjectKey(phone),
                                      controller: phone,
                                      decoration: decoration(context.t.accountDeletion.phonePlaceholder),
                                      keyboardType: TextInputType.phone,
                                    ),
                            ),
                          ),
                          if (state.error.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Text(context.t[state.error], style: TextStyle(color: Theme.of(context).colorScheme.error)),
                            ),
                          if (!passwordRequired) ...[
                            const SizedBox(height: 24),
                            FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                              onPressed: state.loading
                                  ? null
                                  : () async {
                                      if (!await context.read<AccountDeletionCubit>().request(phone.text)) _error();
                                    },
                              child: Text(context.t.accountDeletion.confirm),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
