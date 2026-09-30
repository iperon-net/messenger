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
      if (state.offline) return _offline(context);
      if (state.loadError) return _centeredError(context);
      return const Center(child: CircularProgressIndicator());
    }

    final loading = state.networkStatus == Status.loading;

    switch (state.step) {
      case SettingsCloudPasswordStep.setupEmail:
      case SettingsCloudPasswordStep.changeEmail:
        return _formList([
          _card([
            _row(
              context,
              emailController,
              context.t.cloudPassword.emailPlaceholder,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autofocus: true,
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.setupEmailHint),
        ]);
      case SettingsCloudPasswordStep.setupVerify:
      case SettingsCloudPasswordStep.changeEmailVerify:
        return _formList([
          _card([
            _row(
              context,
              codeController,
              context.t.cloudPassword.codePlaceholder,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              autofocus: true,
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.recoveryHint(email: state.pendingEmail)),
        ]);
      case SettingsCloudPasswordStep.setupPassword:
        return _formList([
          _card([
            _row(
              context,
              passwordController,
              context.t.cloudPassword.passwordPlaceholder,
              obscure: true,
              autofillHints: const [AutofillHints.newPassword],
              autofocus: true,
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.newPasswordDescription),
        ]);
      case SettingsCloudPasswordStep.changePassword:
        return _formList([
          _card([
            _row(
              context,
              passwordController,
              context.t.cloudPassword.newPasswordPlaceholder,
              obscure: true,
              autofillHints: const [AutofillHints.newPassword],
              autofocus: true,
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.changePasswordHint),
        ]);
      case SettingsCloudPasswordStep.unlock:
        return _formList([
          _card([
            _row(
              context,
              passwordController,
              context.t.cloudPassword.passwordPlaceholder,
              obscure: true,
              autofillHints: const [AutofillHints.password],
              autofocus: true,
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.unlockInfo),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: InkWell(
              onTap: loading ? null : () => _cubit.forgotPassword(),
              child: Text(
                context.t.cloudPassword.forgotPassword,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ]);
      case SettingsCloudPasswordStep.recoveryConfirm:
        return _formList([
          _card([
            _row(
              context,
              codeController,
              context.t.cloudPassword.codePlaceholder,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              autofocus: true,
              enabled: !loading,
            ),
            const Divider(height: 0.3, color: Colors.black12),
            _row(
              context,
              passwordController,
              context.t.cloudPassword.newPasswordPlaceholder,
              obscure: true,
              autofillHints: const [AutofillHints.newPassword],
              enabled: !loading,
              error: state.error,
            ),
          ]),
          _desc(context, context.t.cloudPassword.recoveryHint(email: state.maskedEmail)),
        ]);
      case SettingsCloudPasswordStep.menu:
        return _menu(context, state);
      case SettingsCloudPasswordStep.loading:
        return const Center(child: CircularProgressIndicator());
    }
  }

  /// Отдельная страница «нет сети» (стартовая загрузка не прошла из-за отсутствия
  /// связи) — иконка, заголовок/пояснение из общих строк, кнопка «Повторить».
  Widget _offline(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(context.t.common.noConnectionTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              context.t.common.noConnectionMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => _cubit.initialization(), child: Text(context.t.cloudPassword.retry)),
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

  /// Обёртка формы: `ListView` с общим отступом — как в форме редактирования
  /// профиля (settings_my_profile_edit).
  Widget _formList(List<Widget> children) => ListView(padding: const EdgeInsets.all(10), children: children);

  /// Карточка формы (по образцу Card из формы профиля): поля живут внутри белого
  /// блока без собственных рамок.
  Widget _card(List<Widget> children) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(children: children),
  );

  /// Описание под карточкой (вторичный текст).
  Widget _desc(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
    child: Text(text, style: Theme.of(context).textTheme.bodySmall),
  );

  /// Строка-поле формы: безрамочный `TextFormField`, чтобы жить внутри карточки
  /// (по образцу формы профиля). Ошибка — через `errorText` (красным под полем).
  Widget _row(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool enabled = true,
    String? error,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        // Ключ по контроллеру — чтобы при смене шага поле пересоздавалось и
        // клавиатура получала новый keyboardType/autofillHints (см. CLAUDE.md,
        // «Multi-step forms»).
        key: ObjectKey(controller),
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        autofocus: autofocus,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          // Лейбл всегда сверху (как в форме профиля), а не по центру пустого поля.
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          errorStyle: const TextStyle(height: 0.8),
          errorText: (error == null || error.isEmpty) ? null : context.t[error],
        ),
      ),
    );
  }
}
