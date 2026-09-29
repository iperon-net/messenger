import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class AuthCloudPasswordMaterial extends StatefulWidget {
  const AuthCloudPasswordMaterial({super.key});

  @override
  State<AuthCloudPasswordMaterial> createState() => _AuthCloudPasswordMaterial();
}

class _AuthCloudPasswordMaterial extends State<AuthCloudPasswordMaterial> {
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

        return Scaffold(
          appBar: AppBar(title: Text(context.t.cloudPassword.title)),
          body: SafeArea(
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
        TextField(
          controller: passwordController,
          obscureText: true,
          autofocus: true,
          enabled: !loading,
          decoration: InputDecoration(labelText: context.t.cloudPassword.passwordPlaceholder, border: const OutlineInputBorder()),
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
        ),
        _error(context, state),
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: loading ? null : () => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
            child: loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(context.t.cloudPassword.continueButton),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
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
        TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          autofocus: true,
          enabled: !loading,
          decoration: InputDecoration(labelText: context.t.cloudPassword.codePlaceholder, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          enabled: !loading,
          decoration: InputDecoration(labelText: context.t.cloudPassword.newPasswordPlaceholder, border: const OutlineInputBorder()),
        ),
        _error(context, state),
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: loading
                ? null
                : () => context.read<AuthCloudPasswordCubit>().recoveryConfirm(
                    code: codeController.text,
                    newPassword: newPasswordController.text,
                  ),
            child: loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(context.t.cloudPassword.resetPassword),
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
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
