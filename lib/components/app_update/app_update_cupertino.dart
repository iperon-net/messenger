import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_svg/svg.dart';

import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../readable_width.dart';
import 'app_update_common.dart';

/// «Обновите приложение» (iOS): сборка старше минимальной ([AppUpdateGate]).
class AppUpdateCupertino extends StatelessWidget {
  final String current;
  final String minimal;

  const AppUpdateCupertino({super.key, required this.current, required this.minimal});

  @override
  Widget build(BuildContext context) {
    final t = context.t.appUpdate;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final light = CupertinoTheme.brightnessOf(context) == Brightness.light;

    return CupertinoPageScaffold(
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
                        const SizedBox(height: 70, width: double.infinity),
                        SvgPicture.asset(light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
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
                  child: CupertinoButton.filled(onPressed: openAppUpdate, child: Text(t.button)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
