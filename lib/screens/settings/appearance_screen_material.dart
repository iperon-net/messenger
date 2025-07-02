import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/screens/settings/appearance_cubit.dart';

import '../../i18n/translations.g.dart';

class AppearanceScreenMaterial extends StatefulWidget {
  const AppearanceScreenMaterial({super.key});

  @override
  State<AppearanceScreenMaterial> createState() => _AppearanceScreenMaterial();
}

class _AppearanceScreenMaterial extends State<AppearanceScreenMaterial> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.appearance),
      ),
      body: BlocBuilder<AppearanceCubit, AppearanceState>(
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
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );;
  }

}
