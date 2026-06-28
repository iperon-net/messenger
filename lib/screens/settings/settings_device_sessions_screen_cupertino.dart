import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/cubit/settings/settings_cubit.dart';
import 'package:messenger/cubit/settings/settings_device_sessions_state.dart';
import 'package:messenger/cubit/settings/settings_language_state.dart';

import '../../cubit/settings/settings_device_sessions_cubit.dart';
import '../../i18n/translations.g.dart';
import '../../cubit/settings/settings_language_cubit.dart';


class SettingsDeviceSessionsScreenCupertino extends StatefulWidget {
  const SettingsDeviceSessionsScreenCupertino({super.key});

  @override
  State<SettingsDeviceSessionsScreenCupertino> createState() => _SettingsDeviceSessionsScreenCupertino();
}

class _SettingsDeviceSessionsScreenCupertino extends State<SettingsDeviceSessionsScreenCupertino> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _divider() {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          darkColor: const Color(0xFF1C1C1E),
        ),
        context,
      ),
      child: Container(
        height: 0.3,
        color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsDeviceSessionsCubit, SettingsDeviceSessionsState>(
      // listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
        // context.read<MainCubit>().setLocale(locale: state.locale);
        // context.read<SettingsCubit>().setLocale(locale: state.locale);
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGroupedBackground,
            darkColor: CupertinoColors.darkBackgroundGray,
          ),
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.devices),
          ),
          child: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    header: Text(
                      "Это устройство",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    footer: Text(
                      "Выйти на всех устройствах, кроме текущего",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    children: [

                      CupertinoListTile(
                        padding: EdgeInsets.all(10),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF1755DC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.apple, size: 18, color: Color(0xFFFFFFFF)),
                          ),
                        ),
                        title: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Iphone 16 Pro"),
                            Text(
                              "iOS  26.5",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Text('Россия, Москва • в сети'),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
