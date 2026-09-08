import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../themes.dart';

class SettingsMyProfileUsernameCupertino extends StatefulWidget {
  const SettingsMyProfileUsernameCupertino({super.key});

  @override
  State<SettingsMyProfileUsernameCupertino> createState() => _SettingsMyProfileUsernameCupertino();
}

class _SettingsMyProfileUsernameCupertino extends State<SettingsMyProfileUsernameCupertino> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final usernameFocus = FocusNode();

  final logger = getIt.get<Logger>();

  // Последнее значение, проброшенное в контроллер из state (загрузка профиля),
  // чтобы не затирать текст, набранный пользователем, на каждый emit.
  String? _syncedUsername;

  @override
  void dispose() {
    usernameController.dispose();
    usernameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileUsernameCubit, SettingsMyProfileUsernameState>(
      listenWhen: (previous, current) =>
          previous.username != current.username || previous.redirectURI != current.redirectURI || previous.error != current.error,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(context.t.screenMyProfile.error),
              content: Text(context.t[state.error]),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.t.screenMyProfile.close),
                ),
              ],
            ),
          );
          return;
        }

        if (state.redirectURI.isNotEmpty && state.redirectURI == "/settings/profile") return context.pop();

        if (state.username != _syncedUsername) {
          usernameController.text = state.username;
          _syncedUsername = state.username;
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenMyProfile.username),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: Text(context.t.common.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await context.read<SettingsMyProfileUsernameCubit>().setUsername(username: usernameController.text);
                  }
                },
                child: state.networkStatus == Status.loading
                    ? CupertinoActivityIndicator()
                    : Text(context.t.common.save, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
            ),
          ),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  CupertinoFormSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    footer: Padding(padding: const EdgeInsets.only(top: 8), child: Text(context.t.screenMyProfile.usernameDescription)),
                    children: [
                      CupertinoTextFormFieldRow(
                        prefix: const Padding(padding: EdgeInsets.only(right: 4), child: Text("@")),
                        placeholder: context.t.screenMyProfile.usernameHint,
                        controller: usernameController,
                        focusNode: usernameFocus,
                        autofocus: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        // Приводим ввод к нижнему регистру и ограничиваем допустимые символы —
                        // те же правила, что и на сервере.
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                          TextInputFormatter.withFunction((oldValue, newValue) => newValue.copyWith(text: newValue.text.toLowerCase())),
                          LengthLimitingTextInputFormatter(24),
                        ],
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileUsernameCubit>().validate(value)) {
                            UsernameValidationError.invalid => context.t.screenMyProfile.usernameInvalid,
                            null => null,
                          };
                          return error;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
