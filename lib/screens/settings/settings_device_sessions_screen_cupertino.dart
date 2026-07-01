import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/settings/settings_cubit.dart';
import 'package:messenger/cubit/settings/settings_device_sessions_state.dart';
import '../../di.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/string_extensions.dart';

import '../../cubit/settings/settings_device_sessions_cubit.dart';
import '../../i18n/translations.g.dart';
import '../../streams.dart';


class SettingsDeviceSessionsScreenCupertino extends StatefulWidget {
  const SettingsDeviceSessionsScreenCupertino({super.key});

  @override
  State<SettingsDeviceSessionsScreenCupertino> createState() => _SettingsDeviceSessionsScreenCupertino();
}

class _SettingsDeviceSessionsScreenCupertino extends State<SettingsDeviceSessionsScreenCupertino> {
  final streams = getIt.get<Streams>();

  @override
  void initState() {
    super.initState();
    context.read<SettingsDeviceSessionsCubit>().initialization();
  }

  @override
  void dispose() {
    super.dispose();
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

        final currentSession = state.deviceSessions.firstWhereOrNull((data) => data.isCurrent);

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.devices),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.thisDevice.toUpperCase(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                  // footer: Text(
                  //   context.t.logsOutAllDevicesExceptForThisOne,
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  // ),
                  children: [
                    if (currentSession != null)
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
                            Text(currentSession.deviceModel),
                            Text(
                              currentSession.os == 1 ? "iOS ${currentSession.osVersion}" : "Android ${currentSession.osVersion}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Text(context.t.deviceSessionListTileSubtitle(
                            location: LocaleSettings.currentLocale == AppLocale.ru ? currentSession.locationRussian : currentSession.locationEnglish,
                            updateAt: currentSession.updateAt.relativeFormat(context.t)),
                        ),
                      ),
                      if (state.deviceSessions.isNotEmpty && state.deviceSessions.any((data) => data.isCurrent == false))
                        CupertinoListTile(
                          padding: EdgeInsets.all(10),
                          leading: FaIcon(FontAwesomeIcons.hand, size: 18, color: Color(0xFFF40000)),
                          title: Text(
                            context.t.terminateAllOtherSessions,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          onTap: () {},
                        ),
                    ],
                  ),

                if (state.deviceSessions.isNotEmpty && state.deviceSessions.any((data) => data.isCurrent == false))
                  CupertinoListSection.insetGrouped(
                    header: Text(
                      context.t.activeSessions.toUpperCase(),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                    children: [
                      for (final deviceSession in state.deviceSessions)
                        Slidable(
                          key: ValueKey(deviceSession.session),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.3,
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) {},
                                backgroundColor: CupertinoColors.systemRed,
                                foregroundColor: CupertinoColors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: const [
                                    FaIcon(FontAwesomeIcons.circleXmark, size: 20, color: CupertinoColors.white),
                                    Text('Terminate', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          child: CupertinoListTile(
                            padding: EdgeInsets.all(10),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF1755DC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: FaIcon(deviceSession.os == 1 ? FontAwesomeIcons.apple : FontAwesomeIcons.android , size: 18, color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            title: Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(deviceSession.deviceModel),
                                Text(
                                  deviceSession.osVersion,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            subtitle: LocaleSettings.currentLocale == AppLocale.ru ? Text(deviceSession.locationRussian): Text(deviceSession.locationEnglish),
                          ),
                        ),
                    ],
                  ),

              ],
            ),
          ),
        );
      },
    );
  }
}
