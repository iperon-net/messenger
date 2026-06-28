import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/screens/settings/settings_cubit.dart';
import 'package:messenger/screens/settings/settings_language_state.dart';

import '../../i18n/translations.g.dart';
import 'settings_language_cubit.dart';

class SettingsLanguageScreenCupertino extends StatefulWidget {
  const SettingsLanguageScreenCupertino({super.key});

  @override
  State<SettingsLanguageScreenCupertino> createState() => _SettingsLanguageScreenCupertino();
}

class _SettingsLanguageScreenCupertino extends State<SettingsLanguageScreenCupertino> {
  @override
  void initState() {
    super.initState();
    final locate = context.read<MainCubit>().state.settingsDevice.locale;
    context.read<SettingsLanguageCubit>().setLocale(locale: locate ?? AppLocale.en);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _divider() {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          darkColor: const Color(0xFF1C1C1E),
        ),
        context,
      ),
      child: Container(
        height: 0.3,
        color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
      ),
    );
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
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGroupedBackground,
            darkColor: CupertinoColors.darkBackgroundGray,
          ),
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.language),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsetsGeometry.all(15),
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        padding: EdgeInsets.all(10),
                        title: Text("English"),
                        subtitle: Text("English"),
                        onTap: () async => context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.en),
                        additionalInfo: state.locale == AppLocale.en ? additionalInfo : null,
                      ),
                    ),
                    _divider(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        padding: EdgeInsets.all(10),
                        title: Text("Russian"),
                        subtitle: Text("Русский"),
                        onTap: () async => context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.ru),
                        additionalInfo: state.locale == AppLocale.ru ? additionalInfo : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



