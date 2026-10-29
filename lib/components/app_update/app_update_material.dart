import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../readable_width.dart';
import 'app_update_common.dart';

/// «Обновите приложение» (Android, десктоп): сборка старше минимальной
/// ([AppUpdateGate]).
class AppUpdateMaterial extends StatelessWidget {
  final String current;
  final String minimal;

  const AppUpdateMaterial({super.key, required this.current, required this.minimal});

  @override
  Widget build(BuildContext context) {
    final t = context.t.appUpdate;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1B263B) : Colors.white;
    final secondary = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
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
                        const SizedBox(height: 70, width: double.infinity),
                        SvgPicture.asset(isDark ? 'assets/images/logo_dark.svg' : 'assets/images/logo_light.svg'),
                        const SizedBox(height: 18),
                        Text(
                          t.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.emphasis),
                        ),
                        Text(
                          t.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: secondary),
                        ),
                        Text(
                          t.version(current: current, minimal: minimal),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: secondary),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isDark ? const Color.fromARGB(255, 56, 96, 143) : null),
                    onPressed: openAppUpdate,
                    child: Text(t.button),
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
