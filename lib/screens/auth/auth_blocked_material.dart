import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../components/readable_width.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'auth_blocked_common.dart';

/// «Аккаунт заблокирован» — вход отклонён модерацией (`/auth/blocked`).
class AuthBlockedMaterial extends StatelessWidget {
  final AuthBlockedInfo info;

  const AuthBlockedMaterial({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1B263B) : Colors.white;
    final secondary = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      backgroundColor: background,
      body: ReadableWidth(
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
                        SvgPicture.asset(isDark ? 'assets/images/logo_dark.svg' : 'assets/images/logo_light.svg'),
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
                          TextButton(onPressed: info.openSupport, child: Text(info.support)),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isDark ? const Color.fromARGB(255, 56, 96, 143) : null),
                    onPressed: () => context.go("/auth"),
                    child: Text(t.screenAuthBlocked.back),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
