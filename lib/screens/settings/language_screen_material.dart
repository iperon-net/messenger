import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(context.t.language),
      ),
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
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
                      RadioListTile(
                        title: Text("English"),
                        subtitle: Text("English"),
                        value: AppLocale.en,
                        groupValue: state.currentLanguage,
                        onChanged: (value) async => await context.read<LanguageCubit>().changeLanguage(context, language: AppLocale.en),
                      ),
                      RadioListTile(
                        title: Text("Russian"),
                        subtitle: Text("Русский"),
                        value: AppLocale.ru,
                        groupValue: state.currentLanguage,
                        onChanged: (value) async => await context.read<LanguageCubit>().changeLanguage(context, language: AppLocale.ru),
                      ),
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
