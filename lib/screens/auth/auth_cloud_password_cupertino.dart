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

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.cloudPassword.title),
              trailing: _trailing(context, state, loading),
            ),
          ),
          child: SafeArea(
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

  /// Действие в правом верхнем углу — в зависимости от фазы: «Далее» (проверка
  /// пароля / отправка email) или «Сбросить» (подтверждение восстановления).
  Widget _trailing(BuildContext context, AuthCloudPasswordState state, bool loading) {
    final cubit = context.read<AuthCloudPasswordCubit>();
    final (onPressed, label) = switch (state.phase) {
      AuthCloudPasswordPhase.recovery => (
        () => cubit.recoveryConfirm(code: codeController.text, newPassword: newPasswordController.text),
        context.t.cloudPassword.reset,
      ),
      AuthCloudPasswordPhase.enterEmail => (() => cubit.submitRecoveryEmail(emailController.text), context.t.cloudPassword.next),
      AuthCloudPasswordPhase.enterPassword => (() => cubit.submit(passwordController.text), context.t.cloudPassword.next),
    };
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: loading ? null : onPressed,
      child: loading ? const CupertinoActivityIndicator() : Text(label, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
    );
  }

  /// Ввод email восстановления (код придёт, только если адрес совпадает).
  Widget _enterEmail(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoTextField(
          controller: emailController,
          placeholder: context.t.cloudPassword.emailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          enabled: !loading,
          padding: const EdgeInsets.all(12),
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submitRecoveryEmail(emailController.text),
        ),
        _errorText(context, state.error),
        const SizedBox(height: 10),
        Text(
          context.t.cloudPassword.recoveryEmailHint,
          style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13),
        ),
      ],
    );
  }

  Widget _enterPassword(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoTextField(
          controller: passwordController,
          placeholder: context.t.cloudPassword.passwordPlaceholder,
          obscureText: true,
          autofocus: true,
          enabled: !loading,
          padding: const EdgeInsets.all(12),
          onSubmitted: (_) => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
        ),
        _error(context, state),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: loading ? null : () => context.read<AuthCloudPasswordCubit>().startRecovery(),
          child: Text(
            context.t.cloudPassword.forgotPassword,
            style: TextStyle(color: ThemesCupertino.navActionColor(context), fontSize: 13),
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
        CupertinoTextField(
          controller: codeController,
          placeholder: context.t.cloudPassword.codePlaceholder,
          keyboardType: TextInputType.number,
          autofocus: true,
          enabled: !loading,
          padding: const EdgeInsets.all(12),
        ),
        // Ошибки про код — под полем кода; остальные (про пароль/общие) — под паролем.
        _errorText(context, _isCodeError(state.error) ? state.error : ""),
        const SizedBox(height: 12),
        CupertinoTextField(
          controller: newPasswordController,
          placeholder: context.t.cloudPassword.newPasswordPlaceholder,
          obscureText: true,
          enabled: !loading,
          padding: const EdgeInsets.all(12),
        ),
        _errorText(context, _isCodeError(state.error) ? "" : state.error),
      ],
    );
  }

  /// Ошибка про код письма относится к полю кода, всё остальное — к полю пароля.
  bool _isCodeError(String key) => key.toLowerCase().contains("code");

  /// Красная подпись под конкретным полем (пусто — ничего не рисуем).
  Widget _errorText(BuildContext context, String key) {
    if (key.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(context.t[key], style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
    );
  }

  Widget _error(BuildContext context, AuthCloudPasswordState state) {
    final parts = <String>[];
    if (state.error.isNotEmpty) parts.add(context.t[state.error]);
    if (state.attemptsLeft > 0) parts.add(context.t.cloudPassword.attemptsLeftInline(n: state.attemptsLeft));
    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(parts.join(", "), style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
    );
  }
}
