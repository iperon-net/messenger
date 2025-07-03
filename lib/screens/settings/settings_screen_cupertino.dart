import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import 'settings_cubit.dart';


class SettingsScreenCupertino extends StatefulWidget {
  const SettingsScreenCupertino({super.key});

  @override
  State<SettingsScreenCupertino> createState() => _SettingsScreenCupertino();
}

class _SettingsScreenCupertino extends State<SettingsScreenCupertino> {

  @override
  void initState() {
    context.read<SettingsCubit>().initialization();
    super.initState();
  }

  Widget widgetLanguage() {
    String languageName = "English";
    if (LocaleSettings.currentLocale == AppLocale.ru) languageName = "Русский";
    return Text(languageName);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(context.t.settings.settings),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.settings.myPersonalInfo),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.person),
                        title: Text(context.t.settings.myProfile, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.book),
                        title: Text(context.t.settings.favorites, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.settings.settings),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.lock),
                        title: Text(context.t.settings.privacyAndSecurity),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.device_laptop),
                        title: Text(context.t.settings.devices, style: TextStyle(fontSize: 15),),
                        additionalInfo: Text("0"),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.circle_lefthalf_fill),
                        title: Text(context.t.settings.appearance.appearance, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.globe),
                        title: Text(context.t.settings.language.language, style: TextStyle(fontSize: 15),),
                        additionalInfo: widgetLanguage(),
                        trailing: CupertinoListTileChevron(),
                        onTap: () => context.goNamed("settings_language"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
