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
    return _formList([
      _section(
        context,
        description: context.t.cloudPassword.recoveryEmailHint,
        errorText: state.error.isEmpty ? null : context.t[state.error],
        children: [
          _row(
            emailController,
            context.t.cloudPassword.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autofocus: true,
            enabled: !loading,
            onSubmitted: () => context.read<AuthCloudPasswordCubit>().submitRecoveryEmail(emailController.text),
          ),
        ],
      ),
    ]);
  }

  Widget _enterPassword(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return _formList([
      _section(
        context,
        errorText: _composeError(context, state),
        children: [
          _row(
            passwordController,
            context.t.cloudPassword.passwordPlaceholder,
            autofillHints: const [AutofillHints.password],
            obscure: true,
            autofocus: true,
            enabled: !loading,
            onSubmitted: () => context.read<AuthCloudPasswordCubit>().submit(passwordController.text),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(35, 4, 35, 0),
        child: GestureDetector(
          onTap: loading ? null : () => context.read<AuthCloudPasswordCubit>().startRecovery(),
          child: Text(
            context.t.cloudPassword.forgotPassword,
            style: TextStyle(color: ThemesCupertino.navActionColor(context), fontSize: 13),
          ),
        ),
      ),
    ]);
  }

  Widget _recovery(BuildContext context, AuthCloudPasswordState state, bool loading) {
    return _formList([
      _section(
        context,
        description: context.t.cloudPassword.recoveryHint(email: state.pendingEmail),
        errorText: state.error.isEmpty ? null : context.t[state.error],
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
            newPasswordController,
            context.t.cloudPassword.newPasswordPlaceholder,
            autofillHints: const [AutofillHints.newPassword],
            obscure: true,
            enabled: !loading,
          ),
        ],
      ),
    ]);
  }

  /// Ошибка + остаток попыток (для шага ввода пароля), уже переведённые.
  String? _composeError(BuildContext context, AuthCloudPasswordState state) {
    final parts = <String>[];
    if (state.error.isNotEmpty) parts.add(context.t[state.error]);
    if (state.attemptsLeft > 0) parts.add(context.t.cloudPassword.attemptsLeftInline(n: state.attemptsLeft));
    return parts.isEmpty ? null : parts.join(", ");
  }

  /// Обёртка формы: `ListView` с верхним отступом — как в форме профиля.
  Widget _formList(List<Widget> children) => ListView(children: [const SizedBox(height: 20), ...children]);

  /// Grouped inset-карточка формы (по образцу CupertinoFormSection.insetGrouped
  /// из формы профиля). Под карточкой: [errorText] — уже переведённая строка
  /// ошибки (красным), под ней [description] (напр. «код отправлен на …») — оба
  /// видны одновременно, чтобы подсказка не пропадала при ошибке.
  Widget _section(BuildContext context, {String? description, String? errorText, required List<Widget> children}) {
    final lines = <Widget>[
      if (errorText != null && errorText.isNotEmpty)
        Text(errorText, style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
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
  ///
  /// `decoration` — пустой (прозрачный) `BoxDecoration`, а не null: у
  /// borderless-поля без decoration при `enabled: false` CupertinoTextField
  /// заливает фон `_kDisabledBackground` (в тёмной теме почти чёрный 0xFF050505),
  /// и на время запроса («Далее» → loading) строка мигала чёрным.
  Widget _row(
    TextEditingController controller,
    String placeholder, {
    bool obscure = false,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool enabled = true,
    void Function()? onSubmitted,
  }) => CupertinoTextFormFieldRow(
    // Ключ по контроллеру: при смене фазы (пароль → email) поле стоит на той же
    // позиции в дереве, и без ключа Flutter переиспользует State поля — старое
    // соединение с клавиатурой остаётся, и iOS не применяет новый keyboardType
    // (email-раскладку) и autofocus. С ключом поле создаётся заново.
    key: ObjectKey(controller),
    controller: controller,
    placeholder: placeholder,
    decoration: const BoxDecoration(),
    obscureText: obscure,
    keyboardType: keyboardType,
    autofillHints: autofillHints,
    autofocus: autofocus,
    enabled: enabled,
    onFieldSubmitted: onSubmitted == null ? null : (_) => onSubmitted(),
  );
}
