import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants.dart';

import '../../cubit.dart';
import '../../extensions/date_time_extensions.dart';
import '../../i18n/translations.g.dart';

class SettingsDeviceSessionsMaterial extends StatefulWidget {
  const SettingsDeviceSessionsMaterial({super.key});

  @override
  State<SettingsDeviceSessionsMaterial> createState() => _SettingsDeviceSessionsMaterial();
}

class _SettingsDeviceSessionsMaterial extends State<SettingsDeviceSessionsMaterial> {
  Widget _sectionHeader(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
    child: Text(text.toUpperCase(), style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.primary)),
  );

  Widget _deviceLeading(int os) => Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(color: const Color(0xFF1755DC), borderRadius: BorderRadius.circular(8)),
    child: Center(child: FaIcon(os == 1 ? FontAwesomeIcons.apple : FontAwesomeIcons.android, size: 18, color: const Color(0xFFFFFFFF))),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsDeviceSessionsCubit, SettingsDeviceSessionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final currentSessions = state.deviceSessions.where((data) => data.isCurrent);
        final currentSession = currentSessions.isEmpty ? null : currentSessions.first;
        final others = state.deviceSessions.where((data) => data.isCurrent == false).toList()
          ..sort((a, b) => b.updateAt.compareTo(a.updateAt));

        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.screenSettingsDevices.devices),
            actions: [
              if (state.requestStatus == Status.loading)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                ),
            ],
          ),
          body: SafeArea(
            child: currentSession == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      _sectionHeader(context, context.t.screenSettingsDevices.thisDevice),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            ListTile(
                              leading: _deviceLeading(currentSession.os),
                              title: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currentSession.deviceModel),
                                  Text(
                                    currentSession.os == 1 ? "iOS ${currentSession.osVersion}" : "Android ${currentSession.osVersion}",
                                    style: const TextStyle(fontSize: 16),
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
                            if (others.isNotEmpty)
                              ListTile(
                                leading: const FaIcon(FontAwesomeIcons.hand, size: 18, color: Color(0xFFF40000)),
                                title: Text(
                                  context.t.screenSettingsDevices.terminateAllOtherDeviceSessions,
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                ),
                                onTap: () async => await context.read<SettingsDeviceSessionsCubit>().terminate(
                                  others.map((data) => data.sessionID).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (others.isNotEmpty) ...[
                        _sectionHeader(context, context.t.screenSettingsDevices.activeDeviceSession),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              for (final deviceSession in others)
                                Slidable(
                                  key: ValueKey(deviceSession.sessionID),
                                  groupTag: 'device-sessions',
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    extentRatio: 0.25,
                                    dismissible: DismissiblePane(
                                      closeOnCancel: true,
                                      confirmDismiss: () async {
                                        final result = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: Text(context.t.screenSettingsDevices.terminateDeviceSession),
                                            content: Text(context.t.screenSettingsDevices.areYouSureYouLogOutFromThisDevice),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: Text(context.t.screenSettingsDevices.cancel),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                                                child: Text(context.t.screenSettingsDevices.terminateDeviceSession),
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
                                      SlidableAction(
                                        onPressed: (_) {},
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        foregroundColor: Theme.of(context).colorScheme.onError,
                                        icon: Icons.cancel,
                                        label: context.t.screenSettingsDevices.terminate,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: _deviceLeading(deviceSession.os),
                                    title: Column(
                                      spacing: 4,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(deviceSession.deviceModel),
                                        Text(
                                          deviceSession.os == 1 ? "iOS ${deviceSession.osVersion}" : "Android ${deviceSession.osVersion}",
                                          style: const TextStyle(fontSize: 16),
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
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
