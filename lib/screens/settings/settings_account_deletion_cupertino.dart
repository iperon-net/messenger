import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

class SettingsAccountDeletionCupertino extends StatefulWidget {
  const SettingsAccountDeletionCupertino({super.key});
  @override
  State<SettingsAccountDeletionCupertino> createState() => _SettingsAccountDeletionCupertinoState();
}

class _SettingsAccountDeletionCupertinoState extends State<SettingsAccountDeletionCupertino> {
  final phone = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _error() async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.common.noConnectionTitle),
        content: Text(context.t.accountDeletion.requestError),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.pop(dialogContext), child: Text(context.t.common.close))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountDeletionCubit()..load(),
      child: BlocBuilder<AccountDeletionCubit, AccountDeletionState>(
        builder: (context, state) {
          final scheduled = state.manualDeleteAfter;
          return CupertinoPageScaffold(
            backgroundColor: ThemesCupertino.groupedBackground,
            navigationBar: AppCupertinoNavigationBar(child: CupertinoNavigationBar(middle: Text(context.t.accountDeletion.title))),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(context.t.accountDeletion.warning),
                  const SizedBox(height: 20),
                  if (scheduled != null) ...[
                    Text(context.t.accountDeletion.scheduled(date: scheduled.toLocal().toString())),
                    CupertinoButton(
                      color: CupertinoColors.systemRed,
                      onPressed: state.loading
                          ? null
                          : () async {
                              if (!await context.read<AccountDeletionCubit>().cancel()) await _error();
                            },
                      child: Text(context.t.accountDeletion.cancel),
                    ),
                  ] else ...[
                    CupertinoTextField(
                      key: ObjectKey(phone),
                      controller: phone,
                      placeholder: context.t.accountDeletion.phonePlaceholder,
                      keyboardType: TextInputType.phone,
                      decoration: const BoxDecoration(),
                    ),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      key: ObjectKey(password),
                      controller: password,
                      placeholder: context.t.accountDeletion.passwordPlaceholder,
                      obscureText: true,
                      autofillHints: null,
                      decoration: const BoxDecoration(),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton.filled(
                      onPressed: state.loading
                          ? null
                          : () async {
                              if (!await context.read<AccountDeletionCubit>().request(phone.text, password.text)) await _error();
                            },
                      child: Text(context.t.accountDeletion.confirm),
                    ),
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
