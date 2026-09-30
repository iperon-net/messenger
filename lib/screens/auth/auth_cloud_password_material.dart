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
            child: switch (state.phase) {
              AuthCloudPasswordPhase.enterEmail => _enterEmail(context, state, loading),
              AuthCloudPasswordPhase.recovery => _recovery(context, state, loading),
              AuthCloudPasswordPhase.enterPassword => _enterPassword(context, state, loading),
            },
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
          errorText: state.error.isEmpty ? null : context.t[state.error],
          onSubmitted: () => context.read<AuthCloudPasswordCubit>().submitRecoveryEmail(emailController.text),
        ),
      ]),
      _desc(context, context.t.cloudPassword.recoveryEmailHint),
    ]);
  }

  Widget _enterPassword(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return _formList([
      _card([
        _row(
          context,
          passwordController,
          context.t.cloudPassword.passwordPlaceholder,
          autofillHints: const [AutofillHints.password],
          obscure: true,
          autofocus: true,
          enabled: !loading,
          errorText: _composeError(context, state),
          onSubmitted: () => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
        ),
      ]),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        child: InkWell(
          onTap: loading ? null : () => context.read<AuthCloudPasswordCubit>().startRecovery(),
          child: Text(
            context.t.cloudPassword.forgotPassword,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    ]);
  }

  Widget _recovery(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return _formList([
      _card([
        // Ошибки про код — под полем кода; остальные — под паролем.
        _row(
          context,
          codeController,
          context.t.cloudPassword.codePlaceholder,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          autofocus: true,
          enabled: !loading,
          errorText: _isCodeError(state.error) ? context.t[state.error] : null,
        ),
        const Divider(height: 0.3, color: Colors.black12),
        _row(
          context,
          newPasswordController,
          context.t.cloudPassword.newPasswordPlaceholder,
          autofillHints: const [AutofillHints.newPassword],
          obscure: true,
          enabled: !loading,
          errorText: (state.error.isNotEmpty && !_isCodeError(state.error)) ? context.t[state.error] : null,
        ),
      ]),
      _desc(context, context.t.cloudPassword.recoveryHint(email: state.pendingEmail)),
    ]);
  }

  /// Ошибка про код письма относится к полю кода, всё остальное — к полю пароля.
  bool _isCodeError(String key) => key.toLowerCase().contains("code");

  /// Ошибка + остаток попыток (для шага ввода пароля), уже переведённые.
  String? _composeError(BuildContext context, AuthCloudPasswordState state) {
    final parts = <String>[];
    if (state.error.isNotEmpty) parts.add(context.t[state.error]);
    if (state.attemptsLeft > 0) parts.add(context.t.cloudPassword.attemptsLeftInline(n: state.attemptsLeft));
    return parts.isEmpty ? null : parts.join(", ");
  }

  /// Обёртка формы: `ListView` с общим отступом — как в форме профиля.
  Widget _formList(List<Widget> children) => ListView(padding: const EdgeInsets.all(10), children: children);

  /// Карточка формы (по образцу Card из формы профиля).
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
  /// (по образцу формы профиля). Ошибка — через `errorText`.
  Widget _row(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool enabled = true,
    String? errorText,
    void Function()? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        // Ключ по контроллеру: при смене фазы (пароль → email) поле стоит на той же
        // позиции в дереве, и без ключа Flutter переиспользует State поля — старое
        // соединение с клавиатурой остаётся, и она не получает новый keyboardType
        // (email-раскладку) и autofocus. С ключом поле создаётся заново.
        key: ObjectKey(controller),
        controller: controller,
        obscureText: obscure,

        keyboardType: keyboardType,
        autofillHints: autofillHints,
        autofocus: autofocus,
        enabled: enabled,
        onFieldSubmitted: onSubmitted == null ? null : (_) => onSubmitted(),
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
          errorText: (errorText == null || errorText.isEmpty) ? null : errorText,
        ),
      ),
    );
  }
}
