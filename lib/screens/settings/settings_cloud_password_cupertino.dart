import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

class SettingsCloudPasswordCupertino extends StatefulWidget {
  const SettingsCloudPasswordCupertino({super.key});

  @override
  State<SettingsCloudPasswordCupertino> createState() => _SettingsCloudPasswordCupertino();
}

class _SettingsCloudPasswordCupertino extends State<SettingsCloudPasswordCupertino> {
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

  /// Шаги, где действие вынесено в навбар («Далее»): ввод email и подтверждение.
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

  /// Действие в правом верхнем углу: «Сохранить» на установке пароля, «Далее» —
  /// на вводе email и подтверждении; иначе ничего.
  Widget? _trailing(BuildContext context, SettingsCloudPasswordState state) {
    final loading = state.networkStatus == Status.loading;
    if (state.step == SettingsCloudPasswordStep.setupPassword || state.step == SettingsCloudPasswordStep.changePassword) {
      final onSave = state.step == SettingsCloudPasswordStep.setupPassword
          ? () => _cubit.submitSetupPassword(passwordController.text)
          : () => _cubit.submitChangePassword(passwordController.text);
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: loading ? null : onSave,
        child: loading
            ? const CupertinoActivityIndicator()
            : Text(context.t.common.save, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
      );
    }
    if (state.step == SettingsCloudPasswordStep.recoveryConfirm) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: loading ? null : () => _cubit.submitRecovery(code: codeController.text, newPassword: passwordController.text),
        child: loading
            ? const CupertinoActivityIndicator()
            : Text(context.t.cloudPassword.reset, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
      );
    }
    if (_hasNextAction(state.step)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: loading ? null : () => _submitNext(state.step),
        child: loading
            ? const CupertinoActivityIndicator()
            : Text(context.t.cloudPassword.next, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCloudPasswordCubit, SettingsCloudPasswordState>(
      listenWhen: (p, c) => p.step != c.step,
      listener: (context, state) {
        // Смена шага — очищаем поля, чтобы не тащить чужой ввод.
        _clear();
      },
      builder: (context, state) {
        return PopScope(
          canPop: state.isRootStep,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _cubit.back();
          },
          child: CupertinoPageScaffold(
            backgroundColor: ThemesCupertino.groupedBackground,
            navigationBar: AppCupertinoNavigationBar(
              child: CupertinoNavigationBar(
                previousPageTitle: '',
                automaticBackgroundVisibility: false,
                backgroundColor: ThemesCupertino.groupedBackground,
                middle: Text(_title(context, state.step)),
                trailing: _trailing(context, state),
              ),
            ),
            child: SafeArea(child: _body(context, state)),
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
      case SettingsCloudPasswordStep.unlock:
        return context.t.cloudPassword.title;
      case SettingsCloudPasswordStep.recoveryConfirm:
        return context.t.cloudPassword.forgotPassword;
      default:
        return context.t.cloudPassword.title;
    }
  }

  Widget _body(BuildContext context, SettingsCloudPasswordState state) {
    if (state.step == SettingsCloudPasswordStep.loading) {
      if (state.loadError) {
        return _centeredError(context);
      }
      return const Center(child: CupertinoActivityIndicator());
    }

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
              Text(
                context.t.cloudPassword.unlockInfo,
                style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: state.networkStatus == Status.loading ? null : () => _cubit.forgotPassword(),
                child: Text(
                  context.t.cloudPassword.forgotPassword,
                  style: TextStyle(color: ThemesCupertino.navActionColor(context), fontSize: 13),
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
        return const Center(child: CupertinoActivityIndicator());
    }
  }

  Widget _centeredError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.t.cloudPassword.loadError),
          const SizedBox(height: 12),
          CupertinoButton.filled(onPressed: () => _cubit.initialization(), child: Text(context.t.cloudPassword.retry)),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, SettingsCloudPasswordState state) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        CupertinoListSection.insetGrouped(
          footer: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              context.t.cloudPassword.description,
              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13),
            ),
          ),
          backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
          decoration: BoxDecoration(
            color: ThemesCupertino.groupedCard.resolveFrom(context),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          children: [
            CupertinoListTileIcon(
              title: Text(context.t.cloudPassword.changePassword),
              color: const Color(0xFF007AFF),
              icon: FontAwesomeIcons.lock,
              isTrailing: true,
              onTab: () async => _cubit.goChangePassword(),
            ),
            CupertinoListTileIcon(
              title: Text(context.t.cloudPassword.email),
              color: const Color(0xFF34C759),
              icon: FontAwesomeIcons.envelope,
              isTrailing: true,
              additionalInfo: Text(
                state.maskedEmail.isEmpty ? context.t.cloudPassword.emailNotSet : state.maskedEmail,
                style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
              onTab: () async => _cubit.goChangeEmail(),
            ),
            CupertinoListTileIcon(
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
      ],
    );
  }

  /// Поле сверху, описание — снизу; действие живёт в навбаре («Далее» / «Сохранить»).
  /// Используется для ввода email и установки нового пароля.
  Widget _descForm(BuildContext context, {required Widget field, required String description}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field,
          const SizedBox(height: 10),
          Text(description, style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13)),
        ],
      ),
    );
  }

  /// Подпись сверху + одно поле; действие («Далее») живёт в навбаре.
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

  /// Поле ввода. Текст ошибки (если есть) показывается красной подписью вплотную
  /// под полем — как на экране авторизации.
  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String placeholder, {
    bool obscure = false,
    TextInputType? keyboardType,
    String? error,
  }) {
    final field = CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscure,
      keyboardType: keyboardType,
      padding: const EdgeInsets.all(12),
    );
    if (error == null || error.isEmpty) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field,
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(context.t[error], style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
        ),
      ],
    );
  }
}
