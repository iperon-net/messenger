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
      if (state.offline) {
        return _offline(context);
      }
      if (state.loadError) {
        return _centeredError(context);
      }
      return const Center(child: CupertinoActivityIndicator());
    }

    final loading = state.networkStatus == Status.loading;

    switch (state.step) {
      case SettingsCloudPasswordStep.setupEmail:
      case SettingsCloudPasswordStep.changeEmail:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.setupEmailHint,
            error: state.error,
            children: [
              _row(
                emailController,
                context.t.cloudPassword.emailPlaceholder,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autofocus: true,
                enabled: !loading,
              ),
            ],
          ),
        ]);
      case SettingsCloudPasswordStep.setupVerify:
      case SettingsCloudPasswordStep.changeEmailVerify:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.recoveryHint(email: state.pendingEmail),
            error: state.error,
            children: [
              _row(
                codeController,
                context.t.cloudPassword.codePlaceholder,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                autofocus: true,
                enabled: !loading,
              ),
            ],
          ),
        ]);
      case SettingsCloudPasswordStep.setupPassword:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.newPasswordDescription,
            error: state.error,
            children: [
              _row(
                passwordController,
                context.t.cloudPassword.passwordPlaceholder,
                obscure: true,
                autofillHints: const [AutofillHints.newPassword],
                autofocus: true,
                enabled: !loading,
              ),
            ],
          ),
        ]);
      case SettingsCloudPasswordStep.changePassword:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.changePasswordHint,
            error: state.error,
            children: [
              _row(
                passwordController,
                context.t.cloudPassword.newPasswordPlaceholder,
                obscure: true,
                autofillHints: const [AutofillHints.newPassword],
                autofocus: true,
                enabled: !loading,
              ),
            ],
          ),
        ]);
      case SettingsCloudPasswordStep.unlock:
        return _formList([
          _section(
            context,
            description: context.t.cloudPassword.unlockInfo,
            error: state.error,
            children: [
              _row(
                passwordController,
                context.t.cloudPassword.passwordPlaceholder,
                obscure: true,
                autofillHints: const [AutofillHints.password],
                autofocus: true,
                enabled: !loading,
              ),
            ],
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
            description: context.t.cloudPassword.recoveryHint(email: state.maskedEmail),
            error: state.error,
            children: [
              _row(
                codeController,
                context.t.cloudPassword.codePlaceholder,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                autofocus: true,
                enabled: !loading,
              ),
              _row(
                passwordController,
                context.t.cloudPassword.newPasswordPlaceholder,
                obscure: true,
                autofillHints: const [AutofillHints.newPassword],
                enabled: !loading,
              ),
            ],
          ),
        ]);
      case SettingsCloudPasswordStep.menu:
        return _menu(context, state);
      case SettingsCloudPasswordStep.loading:
        return const Center(child: CupertinoActivityIndicator());
    }
  }

  /// Отдельная страница «нет сети» (стартовая загрузка не прошла из-за отсутствия
  /// связи) — иконка, заголовок/пояснение из общих строк, кнопка «Повторить».
  Widget _offline(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.wifi_slash, size: 48, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            const SizedBox(height: 16),
            Text(
              context.t.common.noConnectionTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              context.t.common.noConnectionMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(onPressed: () => _cubit.initialization(), child: Text(context.t.cloudPassword.retry)),
          ],
        ),
      ),
    );
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
  /// из формы профиля). Под карточкой: ошибка ([error], i18n-ключ, красным), под
  /// ней [description] (напр. «код отправлен на …») — оба видны одновременно,
  /// чтобы подсказка не пропадала при ошибке.
  Widget _section(BuildContext context, {String? description, String? error, required List<Widget> children}) {
    final lines = <Widget>[
      if (error != null && error.isNotEmpty) Text(context.t[error], style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
      if (description != null)
        Text(description, style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13)),
    ];

    return CupertinoFormSection.insetGrouped(
      footer: lines.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(13, 2, 13, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: lines),
            ),
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
  /// Ключ по контроллеру — чтобы при смене шага поле пересоздавалось и
  /// клавиатура получала новый keyboardType/autofillHints (см. CLAUDE.md,
  /// «Multi-step forms»).
  Widget _row(
    TextEditingController controller,
    String placeholder, {
    bool obscure = false,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool enabled = true,
  }) => CupertinoTextFormFieldRow(
    key: ObjectKey(controller),
    controller: controller,
    placeholder: placeholder,
    // Прозрачная decoration: иначе отключённое (loading) поле в тёмной теме
    // заливается почти чёрным `_kDisabledBackground` (см. CLAUDE.md).
    decoration: const BoxDecoration(),
    autofocus: autofocus,
    enabled: enabled,
    obscureText: obscure,
    keyboardType: keyboardType,
    autofillHints: autofillHints,
  );
}
