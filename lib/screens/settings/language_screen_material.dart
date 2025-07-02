import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/progress_indicator/progress_indicator.dart';
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
    super.initState();
  }

  List<Map<String, dynamic>> languageList = [
    {"title": "Russian", "subtitle": "Русский", "value": AppLocale.ru},
    {"title": "English", "subtitle": "English", "value": AppLocale.en},
  ];


  List<RadioListTile> radioListTileGenerator(LanguageState state) {
    List<RadioListTile> radioListTileGenerator = [];

    for (final language in languageList){
      radioListTileGenerator.add(
          RadioListTile(
            title: Text(language["title"]),
            subtitle: Text(language["subtitle"]),
            value: language["value"],
            groupValue: state.chooseLanguage,
            onChanged: state.status == Status.loading ? null : (value) async => await context.read<LanguageCubit>().changeLanguage(context, language: language["value"]),
            secondary: (state.status == Status.loading && language["value"] == state.chooseLanguage) ? ProgressIndicatorComponent() : null,
          )
      );
    }
    return radioListTileGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(context.t.language),
      ),
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          // final onChanged = state.status == Status.loading ? {} : await context.read<LanguageCubit>().changeLanguage(context, language: AppLocale.en);

          return ListView(
              padding: EdgeInsets.all(8.0),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text(
                            context.t.interfaceLanguage,
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
    );
  }

}
