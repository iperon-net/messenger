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
      case SettingsCloudPasswordStep.changeEmail:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.setupEmailHint,
            error: state.error,
            children: [_row(emailController, context.t.cloudPassword.emailPlaceholder, keyboardType: TextInputType.emailAddress)],
          ),
        ]);
      case SettingsCloudPasswordStep.setupVerify:
      case SettingsCloudPasswordStep.changeEmailVerify:
        return _formList([
          _section(
            context,
            header: context.t.cloudPassword.recoveryHint(email: state.pendingEmail),
            error: state.error,
            children: [_row(codeController, context.t.cloudPassword.codePlaceholder, keyboardType: TextInputType.number)],
          ),
        ]);
      case SettingsCloudPasswordStep.setupPassword:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.newPasswordDescription,
            error: state.error,
            children: [_row(passwordController, context.t.cloudPassword.passwordPlaceholder, obscure: true)],
          ),
        ]);
      case SettingsCloudPasswordStep.changePassword:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.changePasswordHint,
            error: state.error,
            children: [_row(passwordController, context.t.cloudPassword.newPasswordPlaceholder, obscure: true)],
          ),
        ]);
      case SettingsCloudPasswordStep.unlock:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.unlockInfo,
            error: state.error,
            children: [_row(passwordController, context.t.cloudPassword.passwordPlaceholder, obscure: true)],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 4, 35, 0),
            child: GestureDetector(
              onTap: state.networkStatus == Status.loading ? null : () => _cubit.forgotPassword(),
              child: Text(
                context.t.cloudPassword.forgotPassword,
                style: TextStyle(color: ThemesCupertino.navActionColor(context), fontSize: 13),
              ),
            ),
          ),
        ]);
      case SettingsCloudPasswordStep.recoveryConfirm:
        return _formList([
          _section(
            context,
            header: context.t.cloudPassword.recoveryHint(email: state.maskedEmail),
            error: state.error,
            children: [
              _row(codeController, context.t.cloudPassword.codePlaceholder, keyboardType: TextInputType.number),
              _row(passwordController, context.t.cloudPassword.newPasswordPlaceholder, obscure: true),
            ],
          ),
        ]);
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

  /// Обёртка формы: `ListView` с верхним отступом — как в форме редактирования
  /// профиля (settings_my_profile_edit).
  Widget _formList(List<Widget> children) => ListView(children: [const SizedBox(height: 20), ...children]);

  /// Grouped inset-карточка формы (по образцу CupertinoFormSection.insetGrouped
  /// из формы профиля). [header] — подпись сверху (напр. «код отправлен на …»);
  /// в footer показывается ошибка ([error], красным) либо описание ([description]).
  Widget _section(BuildContext context, {String? header, String? description, String? error, required List<Widget> children}) {
    Widget? footer;
    if (error != null && error.isNotEmpty) {
      footer = Text(context.t[error], style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13));
    } else if (description != null) {
      footer = Text(description, style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13));
    }

    return CupertinoFormSection.insetGrouped(
      header: header != null ? Text(header) : null,
      footer: footer,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      children: children,
    );
  }

  /// Строка-поле формы (по образцу CupertinoTextFormFieldRow из формы профиля).
  Widget _row(TextEditingController controller, String placeholder, {bool obscure = false, TextInputType? keyboardType}) =>
      CupertinoTextFormFieldRow(controller: controller, placeholder: placeholder, obscureText: obscure, keyboardType: keyboardType);
}
