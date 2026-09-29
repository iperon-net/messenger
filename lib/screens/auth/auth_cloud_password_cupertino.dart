import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

class AuthCloudPasswordCupertino extends StatefulWidget {
  const AuthCloudPasswordCupertino({super.key});

  @override
  State<AuthCloudPasswordCupertino> createState() => _AuthCloudPasswordCupertino();
}

class _AuthCloudPasswordCupertino extends State<AuthCloudPasswordCupertino> {
  final passwordController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCloudPasswordCubit, AuthCloudPasswordState>(
      listenWhen: (previous, current) => previous.redirectURI != current.redirectURI,
      listener: (context, state) {
        if (state.redirectURI.isNotEmpty) context.go(state.redirectURI);
      },
      builder: (context, state) {
        final loading = state.networkStatus == Status.loading;

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.cloudPassword.title),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
              child: state.phase == AuthCloudPasswordPhase.recovery
                  ? _recovery(context, state, loading)
                  : _enterPassword(context, state, loading),
            ),
          ),
        );
      },
    );
  }

  Widget _enterPassword(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.cloudPassword.enterPasswordHint, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        CupertinoTextField(
          controller: passwordController,
          placeholder: context.t.cloudPassword.passwordPlaceholder,
          obscureText: true,
          autofocus: true,
          enabled: !loading,
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
        ),
        _error(context, state),
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: CupertinoButton.filled(
            onPressed: loading ? null : () => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
            child: loading ? const CupertinoActivityIndicator() : Text(context.t.cloudPassword.continueButton),
          ),
        ),
        const SizedBox(height: 12),
        CupertinoButton(
          onPressed: loading ? null : () => context.read<AuthCloudPasswordCubit>().startRecovery(),
          child: Text(context.t.cloudPassword.forgotPassword),
        ),
      ],
    );
  }

  Widget _recovery(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.cloudPassword.recoveryHint(email: state.maskedEmail), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        CupertinoTextField(
          controller: codeController,
          placeholder: context.t.cloudPassword.codePlaceholder,
          keyboardType: TextInputType.number,
          autofocus: true,
          enabled: !loading,
        ),
        const SizedBox(height: 12),
        CupertinoTextField(
          controller: newPasswordController,
          placeholder: context.t.cloudPassword.newPasswordPlaceholder,
          obscureText: true,
          enabled: !loading,
        ),
        _error(context, state),
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: CupertinoButton.filled(
            onPressed: loading
                ? null
                : () => context.read<AuthCloudPasswordCubit>().recoveryConfirm(
                    code: codeController.text,
                    newPassword: newPasswordController.text,
                  ),
            child: loading ? const CupertinoActivityIndicator() : Text(context.t.cloudPassword.resetPassword),
          ),
        ),
      ],
    );
  }

  Widget _error(BuildContext context, AuthCloudPasswordState state) {
    final parts = <String>[];
    if (state.error.isNotEmpty) parts.add(context.t[state.error]);
    if (state.attemptsLeft >= 0) parts.add(context.t.cloudPassword.attemptsLeft(count: state.attemptsLeft));
    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        parts.join("\n"),
        textAlign: TextAlign.center,
        style: const TextStyle(color: CupertinoColors.systemRed),
      ),
    );
  }
}
