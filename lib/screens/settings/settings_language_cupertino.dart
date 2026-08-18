import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsLanguageCupertinoScreen extends StatefulWidget {
  const SettingsLanguageCupertinoScreen({super.key});

  @override
  State<SettingsLanguageCupertinoScreen> createState() => _SettingsLanguageCupertinoScreen();
}

class _SettingsLanguageCupertinoScreen extends State<SettingsLanguageCupertinoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget additionalInfo = FaIcon(
      FontAwesomeIcons.solidCircleCheck,
      size: 18,
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).primaryColor,
          darkColor: CupertinoTheme.of(context).primaryColor,
        ),
        context,
      ),
    );

    return BlocConsumer<SettingsLanguageCubit, SettingsLanguageState>(
      listenWhen: (previousState, currentState) => previousState.locale != currentState.locale,
      listener: (context, state) => context.read<CommonCubit>().setLocale(locale: state.locale),
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: AppNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: CupertinoColors.systemGroupedBackground,
              middle: Text(context.t.settings.language),
            ),
          ),
          child: SafeArea(
            child: CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text("English"),
                  subtitle: Text("English"),
                  onTap: () async => await context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.en),
                  additionalInfo: state.locale == AppLocale.en ? additionalInfo : null,
                ),
                CupertinoListTile(
                  title: Text("Russian"),
                  subtitle: Text("Русский"),
                  onTap: () async => await context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.ru),
                  additionalInfo: state.locale == AppLocale.ru ? additionalInfo : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
