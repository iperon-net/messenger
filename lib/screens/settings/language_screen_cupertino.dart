import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/cubit/constants.dart';
import 'package:messenger/screens/settings/settings_cubit.dart';

import '../../i18n/translations.g.dart';
import 'language_cubit.dart';

class LanguageScreenCupertino extends StatefulWidget {
  const LanguageScreenCupertino({super.key});

  @override
  State<LanguageScreenCupertino> createState() => _LanguageScreenCupertino();
}

class _LanguageScreenCupertino extends State<LanguageScreenCupertino> {

  @override
  void initState() {
    context.read<LanguageCubit>().initialization();
    super.initState();
  }
  // state.status == Status.success ? Text(state.languageName): CupertinoActivityIndicator(),

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: t.back,
        middle: Text(context.t.language),
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: BlocBuilder<LanguageCubit, LanguageState>(
          // listener: (context, state) async => await context.read<SettingsCubit>().reloadLanguageName(),
          builder: (context, state) {
            return SingleChildScrollView(
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoFormSection.insetGrouped(
                        header: Text(context.t.interfaceLanguage),
                        children: [
                          CupertinoListTile(
                            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
                            title: Text("English"),
                            subtitle: Text("English"),
                            onTap: () async => state.status == Status.success ? await context.read<LanguageCubit>().changeLanguage(context, language: AppLocale.en) : null,
                            trailing: state.status == Status.loading && state.chooseLanguage == AppLocale.en ? CupertinoActivityIndicator()
                                : (state.chooseLanguage == AppLocale.en ?
                            Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
                          ),
                          CupertinoListTile(
                            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
                            title: Text("Russian"),
                            subtitle: Text("Русский"),
                            onTap: () async => state.status == Status.success ? await context.read<LanguageCubit>().changeLanguage(context, language: AppLocale.ru): null,
                            trailing: state.status == Status.loading && state.chooseLanguage == AppLocale.ru ? CupertinoActivityIndicator()
                                : (state.chooseLanguage == AppLocale.ru ?
                              Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container())
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

}
