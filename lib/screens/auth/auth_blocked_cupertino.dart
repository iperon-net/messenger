import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../components/readable_width.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'auth_blocked_common.dart';

/// «Аккаунт заблокирован» — вход отклонён модерацией (`/auth/blocked`).
class AuthBlockedCupertino extends StatelessWidget {
  final AuthBlockedInfo info;

  const AuthBlockedCupertino({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final light = CupertinoTheme.brightnessOf(context) == Brightness.light;

    return CupertinoPageScaffold(
      navigationBar: AppCupertinoNavigationBar(child: CupertinoNavigationBar()),
      child: ReadableWidth(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 50),
            child: Column(
              spacing: 20,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: [
                        const SizedBox(height: 30, width: double.infinity),
                        SvgPicture.asset(light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                        const SizedBox(height: 18),
                        Text(
                          t.screenAuthBlocked.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.emphasis),
                        ),
                        Text(
                          t.screenAuthBlocked.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: secondary),
                        ),
                        if (info.known) ...[
                          Text(info.reasonText(t), textAlign: TextAlign.center),
                          Text(info.termText(t), textAlign: TextAlign.center),
                        ],
                        if (info.support.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            t.screenAuthBlocked.support,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: secondary),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: info.openSupport,
                            child: Text(info.support, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(onPressed: () => context.go("/auth"), child: Text(t.screenAuthBlocked.back)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
