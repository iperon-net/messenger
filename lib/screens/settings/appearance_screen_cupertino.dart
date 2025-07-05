import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/app_cubit.dart';
import '../../cubit/constants.dart';
import '../../i18n/translations.g.dart';
import 'appearance_cubit.dart';

class AppearanceScreenCupertino extends StatefulWidget {
  const AppearanceScreenCupertino({super.key});

  @override
  State<AppearanceScreenCupertino> createState() => _AppearanceScreenCupertino();
}

class _AppearanceScreenCupertino extends State<AppearanceScreenCupertino> {

  @override
  void initState() {
    context.read<AppearanceCubit>().initialization();
    super.initState();
  }

  List<CupertinoListTile> themeGenerator(BuildContext context, AppearanceState state) {
    List<CupertinoListTile> themeGenerator = [];

    List<Map<String, dynamic>> themeList = [
      {"title": t.settings.appearance.darkMode.system, "value": DarkMode.system},
      {"title": t.settings.appearance.darkMode.disabled, "value": DarkMode.disabled},
      {"title": t.settings.appearance.darkMode.alwaysOn, "value": DarkMode.alwaysOn},
    ];

    for (final theme in themeList){
      themeGenerator.add(
          CupertinoListTile(
            backgroundColorActivated: CupertinoDynamicColor.resolve(CupertinoColors.transparent, context),
            title: Text(theme["title"]),
            onTap: state.status == Status.loading ? () => null : () async => context.read<AppearanceCubit>().changeDarkMode(theme["value"]),
            trailing: (state.status == Status.loading && theme["value"] == state.darkMode) ? CupertinoActivityIndicator() :
              (state.darkMode == theme["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),

            // trailing: (state.status == Status.loading && theme["value"] == state.darkMode) ? CupertinoActivityIndicator() :
            //   (state.darkMode == theme["value"] ? Icon(CupertinoIcons.checkmark_alt, color: CupertinoTheme.of(context).primaryColor) : Container()),
          ),

          // CupertinoListTile(
          //   title: Text(theme["title"]),
          //   value: theme["value"],
            // groupValue: state.darkMode,
            // onChanged: state.status == Status.loading ? (value) => {} : (value) async => context.read<AppearanceCubit>().changeDarkMode(theme["value"]),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
          // )
      );
    }
    return themeGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: t.settings.appearance.back,
        middle: Text(context.t.settings.appearance.appearance),
      ),
      child: SafeArea(
        bottom: true,
        child: BlocBuilder<AppearanceCubit, AppearanceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.settings.appearance.darkMode.darkMode),
                    children: [
                      ...themeGenerator(context, state),
                    ],
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
