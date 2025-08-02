import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/progress_indicator/progress_indicator.dart';
import '../../components/widget_wrapper/widget_wrapper.dart';
import '../../cubit/constants.dart';
import '../../i18n/translations.g.dart';
import 'language_cubit.dart';

class LanguageScreenMaterial extends StatefulWidget {
  const LanguageScreenMaterial({super.key});

  @override
  State<LanguageScreenMaterial> createState() => _LanguageScreenMaterial();
}

class _LanguageScreenMaterial extends State<LanguageScreenMaterial> {

  @override
  void initState() {
    context.read<LanguageCubit>().initialization();
    super.initState();
  }

  List<Map<String, dynamic>> languageList = [
    {"title": "English", "subtitle": "English", "value": AppLocale.en},
    {"title": "Russian", "subtitle": "Русский", "value": AppLocale.ru},
  ];

  List<RadioListTile> radioListTileGenerator(LanguageState state) {
    List<RadioListTile> radioListTileGenerator = [];

    for (final language in languageList){
      radioListTileGenerator.add(
          RadioListTile(
            title: Text(language["title"]),
            subtitle: Text(language["subtitle"]),
            value: language["value"],
            groupValue: LocaleSettings.currentLocale,
            onChanged: state.status == Status.loading ? null : (value) async => await context.read<LanguageCubit>().changeLanguage(context, language: language["value"]),
            secondary: (state.status == Status.loading && language["value"] == state.selectedLanguage) ? ProgressIndicatorComponent() : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
      );
    }
    return radioListTileGenerator;
  }

  @override
  Widget build(BuildContext context) {

    return WidgetWrapper(
        child: Scaffold(
          appBar: AppBar(
          title: Text(context.t.settings.language.language),
        ),
        body: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text(
                            context.t.settings.language.interfaceLanguage,
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                                fontStyle: FontStyle.normal
                            ),
                          )
                      ),
                      ...radioListTileGenerator(state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
