import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/cubit/settings/settings_cubit.dart';
import 'package:messenger/cubit/settings/settings_language_state.dart';

import '../../cubit/settings/settings_language_cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsLanguageScreenCupertino extends StatefulWidget {
  const SettingsLanguageScreenCupertino({super.key});

  @override
  State<SettingsLanguageScreenCupertino> createState() => _SettingsLanguageScreenCupertino();
}

class _SettingsLanguageScreenCupertino extends State<SettingsLanguageScreenCupertino> {
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
    return BlocConsumer<SettingsLanguageCubit, SettingsLanguageState>(
      listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
        context.read<MainCubit>().setLocale(locale: state.locale);
        context.read<SettingsCubit>().setLocale(locale: state.locale);
      },
      builder: (context, state) {
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

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.language),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTile(
                      title: Text("English"),
                      subtitle: Text("English"),
                      onTap: () async => context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.en),
                      additionalInfo: state.locale == AppLocale.en ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text("Russian"),
                      subtitle: Text("Русский"),
                      onTap: () async => context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.ru),
                      additionalInfo: state.locale == AppLocale.ru ? additionalInfo : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



