import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';

import '../../components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants.dart';

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
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenSettingsDevices.devices),
              trailing: state.requestStatus == Status.loading ? CupertinoActivityIndicator() : null,
            ),
          ),
          child: SafeArea(
            child: currentSession == null
                ? const Center(child: CupertinoActivityIndicator())
                : ListView(
                    children: [
                      CupertinoListSection.insetGrouped(
                        backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                        decoration: BoxDecoration(
                          color: ThemesCupertino.groupedCard.resolveFrom(context),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        header: Text(
                          context.t.screenSettingsDevices.thisDevice.toUpperCase(),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                        children: [
                          CupertinoListTile(
                            padding: EdgeInsets.all(10),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: currentSession.os == 1 ? const Color(0xFF1755DC) : const Color(0xFF78C257),
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                              context.t.screenSettingsDevices.deviceSessionListTileSubtitle(
                                location: LocaleSettings.currentLocale == AppLocale.ru
                                    ? currentSession.locationRussian
                                    : currentSession.locationEnglish,
                                updateAt: context.t.screenSettingsDevices.online.toLowerCase(),
                              ),
                            ),
                          ),

                          if (state.deviceSessions.isNotEmpty && state.deviceSessions.any((data) => data.isCurrent == false)) ...[
                            CupertinoListTile(
                              padding: EdgeInsets.all(10),
                              leading: FaIcon(FontAwesomeIcons.hand, size: 18, color: Color(0xFFF40000)),
                              title: Text(
                                context.t.screenSettingsDevices.terminateAllOtherDeviceSessions,
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
                          backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                          decoration: BoxDecoration(
                            color: ThemesCupertino.groupedCard.resolveFrom(context),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          header: Text(
                            context.t.screenSettingsDevices.activeDeviceSession.toUpperCase(),
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
                                          title: Text(context.t.screenSettingsDevices.terminateDeviceSession),
                                          content: Text(context.t.screenSettingsDevices.areYouSureYouLogOutFromThisDevice),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                              onPressed: () => Navigator.pop(context, true),
                                              isDestructiveAction: true,
                                              child: Text(context.t.screenSettingsDevices.terminateDeviceSession),
                                            ),
                                            CupertinoDialogAction(
                                              child: Text(context.t.screenSettingsDevices.cancel),
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
                                          Text(
                                            context.t.screenSettingsDevices.terminate,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
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
                                      color: deviceSession.os == 1 ? const Color(0xFF1755DC) : const Color(0xFF78C257),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
                                    context.t.screenSettingsDevices.deviceSessionListTileSubtitle(
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
