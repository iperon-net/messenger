import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: BlocBuilder<MainCubit, MainState>(
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

                return ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text("English"),
                        subtitle: Text("English"),
                        onTap: () async => context.read<SettingsLanguageCubit>().setLocale(context, locate: AppLocale.en),
                        additionalInfo: state.settingsDevice.locate == AppLocale.en ? additionalInfo : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: CupertinoDynamicColor.resolve(
                          CupertinoDynamicColor.withBrightness(
                            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                            darkColor: Color(0xFF1C1C1E),
                          ),
                          context,
                        ),
                      ),
                      child: CupertinoListTile(
                        title: Text("Russian"),
                        subtitle: Text("Русский"),
                        onTap: () async => context.read<SettingsLanguageCubit>().setLocale(context, locate: AppLocale.ru),
                        additionalInfo: state.settingsDevice.locate == AppLocale.ru ? additionalInfo : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
