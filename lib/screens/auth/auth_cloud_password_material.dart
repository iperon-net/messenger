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
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
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
          appBar: AppBar(title: Text(context.t.cloudPassword.title), actions: _actions(context, state, loading)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
              child: switch (state.phase) {
                AuthCloudPasswordPhase.enterEmail => _enterEmail(context, state, loading),
                AuthCloudPasswordPhase.recovery => _recovery(context, state, loading),
                AuthCloudPasswordPhase.enterPassword => _enterPassword(context, state, loading),
              },
            ),
          ),
        );
      },
    );
  }

  /// Действие справа в AppBar — в зависимости от фазы: «Далее» (проверка пароля /
  /// отправка email) или «Сбросить» (подтверждение восстановления).
  List<Widget> _actions(BuildContext context, AuthCloudPasswordState state, bool loading) {
    final cubit = context.read<AuthCloudPasswordCubit>();
    final (onPressed, label) = switch (state.phase) {
      AuthCloudPasswordPhase.recovery => (
        () => cubit.recoveryConfirm(code: codeController.text, newPassword: newPasswordController.text),
        context.t.cloudPassword.reset,
      ),
      AuthCloudPasswordPhase.enterEmail => (() => cubit.submitRecoveryEmail(emailController.text), context.t.cloudPassword.next),
      AuthCloudPasswordPhase.enterPassword => (() => cubit.submit(passwordController.text), context.t.cloudPassword.next),
    };
    return [
      TextButton(
        onPressed: loading ? null : onPressed,
        child: loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(label),
      ),
    ];
  }

  /// Ввод email восстановления (код придёт, только если адрес совпадает).
  Widget _enterEmail(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          enabled: !loading,
          decoration: InputDecoration(
            labelText: context.t.cloudPassword.emailPlaceholder,
            border: const OutlineInputBorder(),
            errorText: state.error.isEmpty ? null : context.t[state.error],
          ),
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submitRecoveryEmail(emailController.text),
        ),
        const SizedBox(height: 10),
        Text(context.t.cloudPassword.recoveryEmailHint, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _enterPassword(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: passwordController,
          obscureText: true,
          autofocus: true,
          enabled: !loading,
          decoration: InputDecoration(labelText: context.t.cloudPassword.passwordPlaceholder, border: const OutlineInputBorder()),
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
        ),
        _error(context, state),
        const SizedBox(height: 12),
        InkWell(
          onTap: loading ? null : () => context.read<AuthCloudPasswordCubit>().startRecovery(),
          child: Text(
            context.t.cloudPassword.forgotPassword,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _recovery(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.t.cloudPassword.recoveryHint(email: state.pendingEmail), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          autofocus: true,
          enabled: !loading,
          decoration: InputDecoration(
            labelText: context.t.cloudPassword.codePlaceholder,
            border: const OutlineInputBorder(),
            // Ошибки про код — под полем кода; остальные — под паролем.
            errorText: _isCodeError(state.error) ? context.t[state.error] : null,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          enabled: !loading,
          decoration: InputDecoration(
            labelText: context.t.cloudPassword.newPasswordPlaceholder,
            border: const OutlineInputBorder(),
            errorText: (state.error.isNotEmpty && !_isCodeError(state.error)) ? context.t[state.error] : null,
          ),
        ),
      ],
    );
  }

  /// Ошибка про код письма относится к полю кода, всё остальное — к полю пароля.
  bool _isCodeError(String key) => key.toLowerCase().contains("code");

  Widget _error(BuildContext context, AuthCloudPasswordState state) {
    final parts = <String>[];
    if (state.error.isNotEmpty) parts.add(context.t[state.error]);
    if (state.attemptsLeft > 0) parts.add(context.t.cloudPassword.attemptsLeftInline(n: state.attemptsLeft));
    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(parts.join(", "), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error)),
    );
  }
}
