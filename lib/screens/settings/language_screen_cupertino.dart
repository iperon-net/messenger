import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.t.language),
      ),
      child: SafeArea(
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsetsGeometry.all(10),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoFormSection(
                        header: Text(context.t.interfaceLanguage),
                        children: [
                          CupertinoListTile(
                            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
                            title: Text("English"),
                            subtitle: Text("English"),
                            onTap: () async => await context.read<SettingsCubit>().changeLanguage(context, language: AppLocale.en),
                            trailing: context.read<LanguageCubit>().trailingIcon(context, language: AppLocale.en),
                          ),
                          CupertinoListTile(
                            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
                            title: Text("Russian"),
                            subtitle: Text("Русский"),
                            onTap: () async => await context.read<SettingsCubit>().changeLanguage(context, language: AppLocale.ru),
                            trailing: context.read<LanguageCubit>().trailingIcon(context, language: AppLocale.ru),
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
