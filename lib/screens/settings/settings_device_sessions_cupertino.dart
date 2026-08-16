import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../extensions/date_time_extensions.dart';
import '../../i18n/translations.g.dart';

class SettingsDeviceSessionsCupertino extends StatefulWidget {
  const SettingsDeviceSessionsCupertino({super.key});

  @override
  State<SettingsDeviceSessionsCupertino> createState() => _SettingsDeviceSessionsCupertino();
}

class _SettingsDeviceSessionsCupertino extends State<SettingsDeviceSessionsCupertino> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsDeviceSessionsCubit, SettingsDeviceSessionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final currentSessions = state.deviceSessions.where((data) => data.isCurrent);
        final currentSession = currentSessions.isEmpty ? null : currentSessions.first;

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            middle: Text(context.t.settings.devices),
          ),
          child: SafeArea(
            child: currentSession == null
                ? const Center(child: CupertinoActivityIndicator())
                : ListView(
                    children: [
                      CupertinoListSection.insetGrouped(
                        header: Text(
                          context.t.settings.thisDevice.toUpperCase(),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                        children: [
                          CupertinoListTile(
                            padding: EdgeInsets.all(10),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(color: Color(0xFF1755DC), borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: FaIcon(
                                  currentSession.os == 1 ? FontAwesomeIcons.apple : FontAwesomeIcons.android,
                                  size: 18,
                                  color: Color(0xFFFFFFFF),
                                ),
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
                            subtitle: Text(
                              context.t.settings.deviceSessionListTileSubtitle(
                                location: LocaleSettings.currentLocale == AppLocale.ru
                                    ? currentSession.locationRussian
                                    : currentSession.locationEnglish,
                                updateAt: context.t.settings.online.toLowerCase(),
                              ),
                            ),
                          ),

                          if (state.deviceSessions.isNotEmpty && state.deviceSessions.any((data) => data.isCurrent == false)) ...[
                            CupertinoListTile(
                              padding: EdgeInsets.all(10),
                              leading: FaIcon(FontAwesomeIcons.hand, size: 18, color: Color(0xFFF40000)),
                              title: Text(
                                context.t.settings.terminateAllOtherDeviceSessions,
                                style: TextStyle(fontWeight: FontWeight.normal, color: CupertinoColors.destructiveRed),
                              ),
                              onTap: () async => await context.read<SettingsDeviceSessionsCubit>().terminate(
                                state.deviceSessions.where((data) => data.isCurrent == false).map((data) => data.sessionID).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (state.deviceSessions.any((data) => data.isCurrent == false))
                        CupertinoListSection.insetGrouped(
                          header: Text(
                            context.t.settings.activeDeviceSession.toUpperCase(),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                          ),
                          children: [
                            for (final deviceSession
                                in (state.deviceSessions.where((data) => data.isCurrent == false).toList()
                                  ..sort((a, b) => b.updateAt.compareTo(a.updateAt)))) ...[
                              Slidable(
                                key: ValueKey(deviceSession.sessionID),
                                groupTag: 'device-sessions',
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.2,
                                  dismissible: DismissiblePane(
                                    closeOnCancel: true,
                                    confirmDismiss: () async {
                                      final result = await showCupertinoDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) => CupertinoAlertDialog(
                                          title: Text(context.t.settings.terminateDeviceSession),
                                          content: Text(context.t.settings.areYouSureYouLogOutFromThisDevice),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              onPressed: () => Navigator.pop(context, true),
                                              isDestructiveAction: true,
                                              child: Text(context.t.settings.terminateDeviceSession),
                                            ),
                                            CupertinoDialogAction(
                                              child: Text(context.t.common.cancel),
                                              onPressed: () => Navigator.pop(context, false),
                                            ),
                                          ],
                                        ),
                                      );
                                      return result ?? false;
                                    },
                                    onDismissed: () async =>
                                        await context.read<SettingsDeviceSessionsCubit>().terminate([deviceSession.sessionID]),
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
                                          Text(context.t.settings.terminate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                                    decoration: BoxDecoration(color: Color(0xFF1755DC), borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: FaIcon(
                                        deviceSession.os == 1 ? FontAwesomeIcons.apple : FontAwesomeIcons.android,
                                        size: 18,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  title: Column(
                                    spacing: 4,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(deviceSession.deviceModel),
                                      Text(
                                        deviceSession.os == 1 ? "iOS ${deviceSession.osVersion}" : "Android ${deviceSession.osVersion}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    context.t.settings.deviceSessionListTileSubtitle(
                                      location: LocaleSettings.currentLocale == AppLocale.ru
                                          ? deviceSession.locationRussian
                                          : deviceSession.locationEnglish,
                                      updateAt: deviceSession.updateAt.relativeFormat(context.t),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
