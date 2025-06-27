import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/constants.dart';
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
    context.read<SettingsCubit>().initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(context.t.settings),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CupertinoColors.systemGroupedBackground
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.myPersonalInfo),
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.person),
                        title: Text(context.t.myProfile, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.book),
                        title: Text(context.t.favorites, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.lock),
                        title: Text(context.t.privacyAndSecurity),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.device_laptop),
                        title: Text(context.t.devices, style: TextStyle(fontSize: 15),),
                        additionalInfo: Text("0"),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.circle_lefthalf_fill),
                        title: Text(context.t.appearance, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.globe),
                        title: Text(context.t.language, style: TextStyle(fontSize: 15),),
                        additionalInfo: state.status == Status.success ? Text(state.languageName): CupertinoActivityIndicator(),
                        trailing: CupertinoListTileChevron(),
                        onTap: () => context.goNamed("settings_language"),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.arrow_2_circlepath),
                        title: Text(context.t.updates, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.versionApplication, style: TextStyle(fontSize: 15),),
                        additionalInfo: state.status == Status.success ? Text(state.versionApplication): CupertinoActivityIndicator(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
