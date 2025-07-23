import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/cubit/constants.dart';

import '../../components/widget_wrapper/widget_wrapper.dart';
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
            onTap:( state.status == Status.loading || state.selectedLanguage == language["value"]) ? null : () async =>
              await context.read<LanguageCubit>().changeLanguage(context, language: language["value"]),
            trailing: (state.status == Status.loading && language["value"] == state.selectedLanguage) ? CupertinoActivityIndicator() :
              (state.selectedLanguage == language["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
          )
      );
    }
    return cupertinoListTileGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: t.settings.language.back,
          middle: Text(context.t.settings.language.language),
        ),
        child: SafeArea(
          bottom: true,
          child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoFormSection.insetGrouped(
                        header: Text(context.t.settings.language.interfaceLanguage),
                        children: [...cupertinoListTileGenerator(state)],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
