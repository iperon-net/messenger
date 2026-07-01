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
            child: SlidableAutoCloseBehavior(
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
                            updateAt: context.t.online.toLowerCase(),
                          ),
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
                      for (final deviceSession in state.deviceSessions.where((data) => data.isCurrent == false))
                        Slidable(
                          key: ValueKey(deviceSession.session),
                          groupTag: 'device-sessions',
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.2,
                            dismissible: DismissiblePane(
                              // Если confirmDismiss вернёт false — панель сама откатится в закрытое положение.
                              closeOnCancel: true,
                              // Полный свайп: перед завершением показываем диалог-предупреждение.
                              // Вернуть true — сессия завершается, false — панель откатывается назад.
                              confirmDismiss: () async {
                                final result = await showCupertinoDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    // title: Text(context.t.terminateSession),
                                    content: Text(context.t.areYouSureYouLogOutFromThisDevice),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        onPressed: () => Navigator.pop(context, true),  // Возвращаем true
                                        isDestructiveAction: true,
                                        child: Text(context.t.terminateSession), // Красный текст (опасное действие)
                                      ),
                                      CupertinoDialogAction(
                                        child: Text(context.t.cancel),
                                        onPressed: () => Navigator.pop(context, false), // Возвращаем false
                                      ),
                                    ],
                                  ),
                                );
                                return result ?? false;
                              },
                              onDismissed: () async {
                                // Убираем элемент из списка сразу — иначе flutter_slidable
                                // кинет ассерт «dismissed Slidable widget is still part of the tree».
                                await context.read<SettingsDeviceSessionsCubit>().removeSession(deviceSession: deviceSession);
                              },
                            ),
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) {},
                                backgroundColor: CupertinoColors.systemRed,
                                foregroundColor: CupertinoColors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                  children: [
                                    FaIcon(FontAwesomeIcons.circleXmark, size: 20, color: CupertinoColors.white),
                                    Text(context.t.terminate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                            subtitle: Text(context.t.deviceSessionListTileSubtitle(
                              location: LocaleSettings.currentLocale == AppLocale.ru ? deviceSession.locationRussian : deviceSession.locationEnglish,
                              updateAt: deviceSession.updateAt.relativeFormat(context.t)),
                            ),
                          ),
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
