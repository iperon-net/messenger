import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'settings_account_deletion_common.dart';

class SettingsAccountDeletionCupertino extends StatefulWidget {
  const SettingsAccountDeletionCupertino({super.key});
  @override
  State<SettingsAccountDeletionCupertino> createState() => _SettingsAccountDeletionCupertinoState();
}

class _SettingsAccountDeletionCupertinoState extends State<SettingsAccountDeletionCupertino> {
  final formKey = GlobalKey<FormState>();
  final password = TextEditingController();

  @override
  void dispose() {
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
          final passwordRequired = state.cloudPasswordEnabled && !state.cloudPasswordUnlocked;
          return CupertinoPageScaffold(
            backgroundColor: ThemesCupertino.groupedBackground,
            navigationBar: AppCupertinoNavigationBar(
              child: CupertinoNavigationBar(
                automaticBackgroundVisibility: false,
                backgroundColor: ThemesCupertino.groupedBackground,
                middle: Text(context.t.accountDeletion.title),
                trailing: state.loaded && scheduled == null && passwordRequired
                    ? NavBarButtonCupertino(
                        NavBarAction.done,
                        label: context.t.common.kContinue,
                        loading: state.loading,
                        onPressed: () async {
                          final cubit = context.read<AccountDeletionCubit>();
                          if (!await cubit.unlock(password.text) && cubit.state.error.isEmpty) await _error();
                        },
                      )
                    : null,
              ),
            ),
            child: !state.loaded
                ? Center(
                    child: state.loading
                        ? const CupertinoActivityIndicator()
                        : CupertinoButton(
                            onPressed: () => context.read<AccountDeletionCubit>().load(),
                            child: Text(context.t.cloudPassword.retry),
                          ),
                  )
                : Form(
                    key: formKey,
                    child: SafeArea(
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          if (scheduled != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(context.t.accountDeletion.warning, style: const TextStyle(fontSize: AppFontSizes.caption)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                              child: AccountDeletionScheduledText(
                                t: context.t,
                                scheduled: scheduled,
                                style: const TextStyle(fontSize: AppFontSizes.caption),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoButton(
                                color: CupertinoColors.systemRed,
                                onPressed: state.loading
                                    ? null
                                    : () async {
                                        if (!await context.read<AccountDeletionCubit>().cancel()) await _error();
                                      },
                                child: Text(context.t.accountDeletion.cancel, style: const TextStyle(color: CupertinoColors.white)),
                              ),
                            ),
                          ] else ...[
                            if (passwordRequired)
                              CupertinoFormSection.insetGrouped(
                                clipBehavior: Clip.antiAlias,
                                backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                                decoration: BoxDecoration(
                                  color: ThemesCupertino.groupedCard.resolveFrom(context),
                                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                                ),
                                footer: Padding(padding: const EdgeInsets.only(top: 8), child: Text(context.t.cloudPassword.unlockInfo)),
                                children: [
                                  CupertinoTextFormFieldRow(
                                    key: ObjectKey(password),
                                    controller: password,
                                    placeholder: context.t.cloudPassword.passwordPlaceholder,
                                    obscureText: true,
                                    autofillHints: const [AutofillHints.password],
                                    autofocus: true,
                                    // Кнопка «Готово» на клавиатуре срабатывает как «Продолжить».
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: state.loading
                                        ? null
                                        : (_) async {
                                            final cubit = context.read<AccountDeletionCubit>();
                                            if (!await cubit.unlock(password.text) && cubit.state.error.isEmpty) await _error();
                                          },
                                  ),
                                ],
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                child: Text(context.t.accountDeletion.warning, style: const TextStyle(fontSize: AppFontSizes.caption)),
                              ),
                            if (state.error.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(35, 8, 35, 0),
                                child: Text(context.t[state.error], style: const TextStyle(color: CupertinoColors.systemRed)),
                              ),
                            if (!passwordRequired)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: CupertinoButton.filled(
                                  color: CupertinoColors.systemRed,
                                  onPressed: state.loading
                                      ? null
                                      : () async {
                                          if (!await context.read<AccountDeletionCubit>().request()) await _error();
                                        },
                                  child: Text(context.t.accountDeletion.confirm, style: const TextStyle(color: CupertinoColors.white)),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
