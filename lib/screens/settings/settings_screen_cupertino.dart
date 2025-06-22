import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.t.settings),
      ),
      child: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {

            return SingleChildScrollView(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoFormSection(
                    header: Text(context.t.myPersonalInfo),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.person),
                        title: Text(context.t.myProfile),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                        ),
                      ),
                    ],
                  ),
                  CupertinoFormSection(
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.book),
                        title: Text(context.t.favorites),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                        ),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.lock),
                        title: Text(context.t.privacyAndSecurity),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                        ),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.circle_lefthalf_fill),
                        title: Text(context.t.appearance),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                        ),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.globe),
                        title: Text(context.t.language),
                        additionalInfo: Text(state.languageName),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
                        ),
                      ),
                    ],
                  ),
                  CupertinoFormSection(
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.versionApplication),
                        additionalInfo: Text(state.versionApplication),
                      ),
                    ]
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
