import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/cubit/constants.dart';

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

  List<Map<String, dynamic>> languageList = [
    {"title": "Russian", "subtitle": "Русский", "value": AppLocale.ru},
    {"title": "English", "subtitle": "English", "value": AppLocale.en},
  ];

  List<CupertinoListTile> cupertinoListTileGenerator(LanguageState state) {
    List<CupertinoListTile> cupertinoListTileGenerator = [];

    for (final language in languageList){
      cupertinoListTileGenerator.add(
          CupertinoListTile(
            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
            title: Text(language["title"]),
            subtitle: Text(language["subtitle"]),
            onTap:( state.status == Status.loading || state.chooseLanguage == language["value"]) ? null : () async =>
              await context.read<LanguageCubit>().changeLanguage(context, language: language["value"]),
            trailing: (state.status == Status.loading && language["value"] == state.chooseLanguage) ? CupertinoActivityIndicator() :
              (state.chooseLanguage == language["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
          )
      );
    }
    return cupertinoListTileGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: t.back,
        middle: Text(context.t.language),
      ),
      child: SafeArea(
        bottom: true,
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.interfaceLanguage),
                    children: [...cupertinoListTileGenerator(state)],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}
