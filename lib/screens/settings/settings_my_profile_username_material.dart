import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../themes.dart';

class SettingsMyProfileUsernameMaterial extends StatefulWidget {
  const SettingsMyProfileUsernameMaterial({super.key});

  @override
  State<SettingsMyProfileUsernameMaterial> createState() => _SettingsMyProfileUsernameMaterial();
}

class _SettingsMyProfileUsernameMaterial extends State<SettingsMyProfileUsernameMaterial> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final usernameFocus = FocusNode();

  final logger = getIt.get<Logger>();

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
          showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(context.t.screenMyProfile.error),
              content: Text(context.t[state.error]),
              actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: Text(context.t.screenMyProfile.close))],
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
        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.screenMyProfile.username),
            actions: [
              state.networkStatus == Status.loading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await context.read<SettingsMyProfileUsernameCubit>().setUsername(username: usernameController.text);
                        }
                      },
                      child: FaIcon(FontAwesomeIcons.check, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
            ],
          ),
          body: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: usernameController,
                        focusNode: usernameFocus,
                        autofocus: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                          TextInputFormatter.withFunction((oldValue, newValue) => newValue.copyWith(text: newValue.text.toLowerCase())),
                          LengthLimitingTextInputFormatter(24),
                        ],
                        decoration: InputDecoration(
                          prefixText: "@",
                          labelText: context.t.screenMyProfile.username,
                          hintText: context.t.screenMyProfile.usernameHint,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          errorStyle: const TextStyle(height: 0.8),
                          errorMaxLines: 2,
                        ),
                        validator: (value) => switch (context.read<SettingsMyProfileUsernameCubit>().validate(value)) {
                          UsernameValidationError.invalid => context.t.screenMyProfile.usernameInvalid,
                          null => null,
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      context.t.screenMyProfile.usernameDescription,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: AppFontSizes.label),
                    ),
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
