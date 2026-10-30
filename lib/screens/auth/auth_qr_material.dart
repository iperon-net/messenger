import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../accounts.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'auth_material.dart';

/// Экран входа на десктопе: только QR с телефона (docs/plans/desktop-client.md
/// §3.4), без номера, Яндекса и passkey. В debug-сборке есть ссылка на обычный
/// вход по номеру — для разработки, пока у тестового аккаунта нет телефона под
/// рукой. При «Добавить аккаунт» — крестик и Esc: назад в прежний аккаунт
/// ([cancelAddAccount]).
class AuthDesktopMaterial extends StatefulWidget {
  const AuthDesktopMaterial({super.key});

  @override
  State<AuthDesktopMaterial> createState() => _AuthDesktopMaterialState();
}

class _AuthDesktopMaterialState extends State<AuthDesktopMaterial> {
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
    if (_phone) return const AuthMaterialScreen();
    return BlocProvider(
      create: (_) => AuthQrCubit()..initialization(),
      child: _AuthQrMaterial(
        onPhoneLogin: kDebugMode ? () => setState(() => _phone = true) : null,
        onCancel: _canReturn ? cancelAddAccount : null,
      ),
    );
  }
}

class _AuthQrMaterial extends StatelessWidget {
  const _AuthQrMaterial({required this.onPhoneLogin, required this.onCancel});

  final VoidCallback? onPhoneLogin;

  /// Отмена добавления аккаунта; null — других аккаунтов нет.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final t = context.t.authQr;
    final scheme = Theme.of(context).colorScheme;
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
                style: TextStyle(color: scheme.error),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(onPressed: () => context.read<AuthQrCubit>().retry(), child: Text(t.retry)),
            ],
          );
        } else if (state.completing || state.status != Status.success || state.qrData.isEmpty) {
          code = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              if (state.completing) ...[const SizedBox(height: 12), Text(t.completing)],
            ],
          );
        } else {
          // Тёмные модули на белом в любой теме — так QR читают все камеры.
          code = DecoratedBox(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: QrImageView(data: state.qrData, size: 232, backgroundColor: Colors.white),
            ),
          );
        }

        final cancel = onCancel;
        final screen = Scaffold(
          appBar: cancel != null
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(tooltip: context.t.common.cancel, icon: const Icon(Icons.close), onPressed: cancel),
                )
              : null,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(width: 256, height: 256, child: Center(child: code)),
                    const SizedBox(height: 24),
                    Text(t.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    for (final (index, step) in [t.step1, t.step2, t.step3].indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: scheme.primary,
                              child: Text('${index + 1}', style: TextStyle(fontSize: 12, color: scheme.onPrimary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(step)),
                          ],
                        ),
                      ),
                    if (onPhoneLogin != null) ...[
                      const SizedBox(height: 16),
                      TextButton(onPressed: onPhoneLogin, child: Text(t.phoneLogin)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
        if (cancel == null) return screen;
        return CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.escape): cancel},
          child: Focus(autofocus: true, child: screen),
        );
      },
    );
  }
}
