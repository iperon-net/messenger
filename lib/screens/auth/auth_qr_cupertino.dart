import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../accounts.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'auth_cupertino.dart';

/// Вход на iPad: только QR с телефона, как на десктопе (`AuthDesktopMaterial`),
/// без номера, Яндекса и passkey. В debug-сборке есть ссылка на обычный вход
/// по номеру — для разработки. При «Добавить аккаунт» — «Отмена»: назад в
/// прежний аккаунт ([cancelAddAccount]).
class AuthQrCupertino extends StatefulWidget {
  const AuthQrCupertino({super.key});

  @override
  State<AuthQrCupertino> createState() => _AuthQrCupertinoState();
}

class _AuthQrCupertinoState extends State<AuthQrCupertino> {
  bool _phone = false;

  /// Есть вошедший аккаунт, куда вернуться (добавляем ещё один).
  bool _canReturn = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      returnAccount().then((id) {
        if (mounted && id != null) setState(() => _canReturn = true);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_phone) return AuthCupertinoScreen();
    return BlocProvider(
      create: (_) => AuthQrCubit()..initialization(),
      child: _AuthQrCupertinoView(
        onPhoneLogin: kDebugMode ? () => setState(() => _phone = true) : null,
        onCancel: _canReturn ? cancelAddAccount : null,
      ),
    );
  }
}

class _AuthQrCupertinoView extends StatelessWidget {
  const _AuthQrCupertinoView({required this.onPhoneLogin, required this.onCancel});

  final VoidCallback? onPhoneLogin;

  /// Отмена добавления аккаунта; null — других аккаунтов нет.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final t = context.t.authQr;
    final accent = CupertinoTheme.of(context).primaryColor;
    return BlocConsumer<AuthQrCubit, AuthQrState>(
      listenWhen: (previous, current) => previous.redirectURI != current.redirectURI && current.redirectURI.isNotEmpty,
      listener: (context, state) => context.go(state.redirectURI),
      builder: (context, state) {
        final Widget code;
        if (state.error.isNotEmpty) {
          String message;
          try {
            message = context.t[state.error];
          } catch (_) {
            message = context.t.grpcError.unknownError;
          }
          code = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: CupertinoColors.destructiveRed),
              ),
              const SizedBox(height: 12),
              CupertinoButton.tinted(onPressed: () => context.read<AuthQrCubit>().retry(), child: Text(t.retry)),
            ],
          );
        } else if (state.completing || state.status != Status.success || state.qrData.isEmpty) {
          code = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(),
              if (state.completing) ...[const SizedBox(height: 12), Text(t.completing)],
            ],
          );
        } else {
          // Тёмные модули на белом в любой теме — так QR читают все камеры.
          code = DecoratedBox(
            decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: QrImageView(data: state.qrData, size: 232, backgroundColor: CupertinoColors.white),
            ),
          );
        }

        final light = CupertinoTheme.brightnessOf(context) == Brightness.light;
        final cancel = onCancel;
        return CupertinoPageScaffold(
          navigationBar: cancel != null
              ? CupertinoNavigationBar(
                  automaticBackgroundVisibility: false,
                  backgroundColor: const Color(0x00000000),
                  border: null,
                  leading: NavBarButtonCupertino(NavBarAction.cancel, label: context.t.common.cancel, onPressed: cancel),
                )
              : null,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                      const SizedBox(height: 24),
                      SizedBox(width: 256, height: 256, child: Center(child: code)),
                      const SizedBox(height: 24),
                      Text(t.title, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(fontSize: 22)),
                      const SizedBox(height: 16),
                      for (final (index, step) in [t.step1, t.step2, t.step3].indexed)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                                child: Text('${index + 1}', style: TextStyle(fontSize: 12, color: ThemesCupertino.onAccent(context))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(step)),
                            ],
                          ),
                        ),
                      if (onPhoneLogin != null) ...[
                        const SizedBox(height: 16),
                        CupertinoButton(onPressed: onPhoneLogin, child: Text(t.phoneLogin)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
