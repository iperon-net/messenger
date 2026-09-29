import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsCloudPasswordMaterial extends StatefulWidget {
  const SettingsCloudPasswordMaterial({super.key});

  @override
  State<SettingsCloudPasswordMaterial> createState() => _SettingsCloudPasswordMaterial();
}

class _SettingsCloudPasswordMaterial extends State<SettingsCloudPasswordMaterial> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clear() {
    emailController.clear();
    codeController.clear();
    passwordController.clear();
  }

  SettingsCloudPasswordCubit get _cubit => context.read<SettingsCloudPasswordCubit>();

  /// Шаги, где действие вынесено в AppBar («Далее»): ввод email и подтверждение.
  bool _hasNextAction(SettingsCloudPasswordStep step) => switch (step) {
    SettingsCloudPasswordStep.setupEmail ||
    SettingsCloudPasswordStep.changeEmail ||
    SettingsCloudPasswordStep.setupVerify ||
    SettingsCloudPasswordStep.changeEmailVerify ||
    SettingsCloudPasswordStep.unlock => true,
    _ => false,
  };

  void _submitNext(SettingsCloudPasswordStep step) {
    switch (step) {
      case SettingsCloudPasswordStep.setupEmail:
        _cubit.submitSetupEmail(emailController.text);
      case SettingsCloudPasswordStep.changeEmail:
        _cubit.submitChangeEmail(emailController.text);
      case SettingsCloudPasswordStep.setupVerify:
        _cubit.submitSetupVerify(codeController.text);
      case SettingsCloudPasswordStep.changeEmailVerify:
        _cubit.submitChangeEmailVerify(codeController.text);
      case SettingsCloudPasswordStep.unlock:
        _cubit.unlock(passwordController.text);
      default:
        break;
    }
  }

  /// Действие справа в AppBar: «Сохранить» на установке пароля, «Далее» — на
  /// вводе email и подтверждении; иначе пусто.
  List<Widget> _actions(BuildContext context, SettingsCloudPasswordState state) {
    final loading = state.networkStatus == Status.loading;
    if (state.step == SettingsCloudPasswordStep.setupPassword || state.step == SettingsCloudPasswordStep.changePassword) {
      final onSave = state.step == SettingsCloudPasswordStep.setupPassword
          ? () => _cubit.submitSetupPassword(passwordController.text)
          : () => _cubit.submitChangePassword(passwordController.text);
      return [
        TextButton(
          onPressed: loading ? null : onSave,
          child: loading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.t.common.save),
        ),
      ];
    }
    if (state.step == SettingsCloudPasswordStep.recoveryConfirm) {
      return [
        TextButton(
          onPressed: loading ? null : () => _cubit.submitRecovery(code: codeController.text, newPassword: passwordController.text),
          child: loading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.t.cloudPassword.reset),
        ),
      ];
    }
    if (_hasNextAction(state.step)) {
      return [TextButton(onPressed: loading ? null : () => _submitNext(state.step), child: Text(context.t.cloudPassword.next))];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCloudPasswordCubit, SettingsCloudPasswordState>(
      listenWhen: (p, c) => p.step != c.step,
      listener: (context, state) => _clear(),
      builder: (context, state) {
        return PopScope(
          canPop: state.isRootStep,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _cubit.back();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(_title(context, state.step)),
              leading: BackButton(onPressed: () => state.isRootStep ? context.pop() : _cubit.back()),
              actions: _actions(context, state),
            ),
            body: SafeArea(child: _body(context, state)),
          ),
        );
      },
    );
  }

  String _title(BuildContext context, SettingsCloudPasswordStep step) {
    switch (step) {
      case SettingsCloudPasswordStep.setupEmail:
      case SettingsCloudPasswordStep.changeEmail:
        return context.t.cloudPassword.email;
      case SettingsCloudPasswordStep.setupVerify:
      case SettingsCloudPasswordStep.changeEmailVerify:
        return context.t.cloudPassword.verifyEmail;
      case SettingsCloudPasswordStep.setupPassword:
        return context.t.cloudPassword.newPasswordTitle;
      case SettingsCloudPasswordStep.changePassword:
        return context.t.cloudPassword.changePassword;
      case SettingsCloudPasswordStep.recoveryConfirm:
        return context.t.cloudPassword.forgotPassword;
      default:
        return context.t.cloudPassword.title;
    }
  }

  Widget _body(BuildContext context, SettingsCloudPasswordState state) {
    if (state.step == SettingsCloudPasswordStep.loading) {
      if (state.loadError) return _centeredError(context);
      return const Center(child: CircularProgressIndicator());
    }

    final loading = state.networkStatus == Status.loading;

    switch (state.step) {
      case SettingsCloudPasswordStep.setupEmail:
        return _descForm(
          context,
          field: _field(
            context,
            emailController,
            context.t.cloudPassword.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            error: state.error,
          ),
          description: context.t.cloudPassword.setupEmailHint,
        );
      case SettingsCloudPasswordStep.setupVerify:
        return _promptForm(
          context,
          hint: context.t.cloudPassword.recoveryHint(email: state.pendingEmail),
          field: _field(
            context,
            codeController,
            context.t.cloudPassword.codePlaceholder,
            keyboardType: TextInputType.number,
            error: state.error,
          ),
        );
      case SettingsCloudPasswordStep.setupPassword:
        return _descForm(
          context,
          field: _field(context, passwordController, context.t.cloudPassword.passwordPlaceholder, obscure: true, error: state.error),
          description: context.t.cloudPassword.newPasswordDescription,
        );
      case SettingsCloudPasswordStep.unlock:
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(context, passwordController, context.t.cloudPassword.passwordPlaceholder, obscure: true, error: state.error),
              const SizedBox(height: 10),
              Text(context.t.cloudPassword.unlockInfo, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              InkWell(
                onTap: loading ? null : () => _cubit.forgotPassword(),
                child: Text(
                  context.t.cloudPassword.forgotPassword,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        );
      case SettingsCloudPasswordStep.changePassword:
        return _descForm(
          context,
          field: _field(context, passwordController, context.t.cloudPassword.newPasswordPlaceholder, obscure: true, error: state.error),
          description: context.t.cloudPassword.changePasswordHint,
        );
      case SettingsCloudPasswordStep.changeEmail:
        return _descForm(
          context,
          field: _field(
            context,
            emailController,
            context.t.cloudPassword.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            error: state.error,
          ),
          description: context.t.cloudPassword.setupEmailHint,
        );
      case SettingsCloudPasswordStep.changeEmailVerify:
        return _promptForm(
          context,
          hint: context.t.cloudPassword.recoveryHint(email: state.pendingEmail),
          field: _field(
            context,
            codeController,
            context.t.cloudPassword.codePlaceholder,
            keyboardType: TextInputType.number,
            error: state.error,
          ),
        );
      case SettingsCloudPasswordStep.recoveryConfirm:
        return _promptForm(
          context,
          hint: context.t.cloudPassword.recoveryHint(email: state.maskedEmail),
          field: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(context, codeController, context.t.cloudPassword.codePlaceholder, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _field(context, passwordController, context.t.cloudPassword.newPasswordPlaceholder, obscure: true, error: state.error),
            ],
          ),
        );
      case SettingsCloudPasswordStep.menu:
        return _menu(context, state);
      case SettingsCloudPasswordStep.loading:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _centeredError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.t.cloudPassword.loadError),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => _cubit.initialization(), child: Text(context.t.cloudPassword.retry)),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, SettingsCloudPasswordState state) {
    return ListView(
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              MaterialListTileIcon(
                title: Text(context.t.cloudPassword.changePassword),
                color: const Color(0xFF007AFF),
                icon: FontAwesomeIcons.lock,
                isTrailing: true,
                onTab: () async => _cubit.goChangePassword(),
              ),
              MaterialListTileIcon(
                title: Text(context.t.cloudPassword.email),
                subtitle: Text(state.maskedEmail.isEmpty ? context.t.cloudPassword.emailNotSet : state.maskedEmail),
                color: const Color(0xFF34C759),
                icon: FontAwesomeIcons.envelope,
                isTrailing: true,
                onTab: () async => _cubit.goChangeEmail(),
              ),
              MaterialListTileIcon(
                title: Text(context.t.cloudPassword.disable),
                color: const Color(0xFFFF3B30),
                icon: FontAwesomeIcons.lockOpen,
                isTrailing: true,
                onTab: () async {
                  if (await _cubit.disable() && context.mounted) context.pop();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(context.t.cloudPassword.description, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  /// Поле сверху, описание — снизу; действие живёт в AppBar («Далее» / «Сохранить»).
  /// Используется для ввода email и установки нового пароля.
  Widget _descForm(BuildContext context, {required Widget field, required String description}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field,
          const SizedBox(height: 10),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  /// Подпись сверху + одно поле; действие («Далее») живёт в AppBar.
  /// Используется на подтверждении email и установке пароля.
  Widget _promptForm(BuildContext context, {required String hint, required Widget field}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(hint, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          field,
        ],
      ),
    );
  }

  /// Поле ввода. Текст ошибки (если есть) показывается штатно внутри декорации
  /// input (`errorText`) — красной подписью под полем, как на экране авторизации.
  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType? keyboardType,
    String? error,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: (error == null || error.isEmpty) ? null : context.t[error],
      ),
    );
  }
}
