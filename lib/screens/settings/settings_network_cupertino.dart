import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'settings_data_common.dart';

/// «Использование трафика» (iOS): мобильная сеть / Wi-Fi, диаграмма и
/// отправлено / получено по категориям, сброс статистики.
class SettingsNetworkCupertino extends StatelessWidget {
  const SettingsNetworkCupertino({super.key});

  CupertinoListSection _section(BuildContext context, {String? footer, required List<Widget> children}) {
    return CupertinoListSection.insetGrouped(
      footer: footer == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(footer, style: TextStyle(fontSize: AppFontSizes.caption)),
            ),
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: children,
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final t = context.t.screenSettingsData;
    final cubit = context.read<SettingsNetworkCubit>();
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.resetTitle),
        content: Text(t.resetMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.reset)),
        ],
      ),
    );
    if (ok == true) await cubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    return BlocBuilder<SettingsNetworkCubit, SettingsNetworkState>(
      builder: (context, state) {
        final cubit = context.read<SettingsNetworkCubit>();
        final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
        final usage = state.current;
        final total = state.total;
        final categories = [
          for (final category in models.TrafficCategory.values)
            if ((usage[category]?.total ?? 0) > 0) category,
        ];
        final since = state.since;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticallyImplyLeading: !context.isSplitPaneRoot,
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.networkUsage),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: CupertinoSlidingSegmentedControl<models.NetworkKind>(
                    groupValue: state.network,
                    onValueChanged: (network) {
                      if (network != null) cubit.setNetwork(network);
                    },
                    children: {for (final network in models.NetworkKind.values) network: Text(networkTitle(context.t, network))},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Center(
                    child: UsageDonut(
                      segments: trafficSegments(usage),
                      emptyColor: CupertinoColors.systemFill.resolveFrom(context),
                      center: state.status != Status.success
                          ? const CupertinoActivityIndicator()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  child: Text(
                                    formatBytes(context, total.total),
                                    style: TextStyle(fontSize: AppFontSizes.emphasisLarge, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  networkTitle(context.t, state.network),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                _section(
                  context,
                  footer: t.networkNote,
                  children: [
                    if (categories.isEmpty)
                      CupertinoListTile(
                        title: Text(t.noTraffic, style: TextStyle(color: secondary)),
                      ),
                    for (final category in categories)
                      CupertinoListTile(
                        leading: UsageDot(trafficCategoryColor(category)),
                        leadingSize: 12,
                        title: Text(trafficCategoryTitle(context.t, category)),
                        subtitle: Text(trafficCounterText(context, usage[category]!)),
                        additionalInfo: Text(formatBytes(context, usage[category]!.total), style: TextStyle(color: secondary)),
                      ),
                    if (categories.isNotEmpty)
                      CupertinoListTile(
                        title: Text(t.total, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(trafficCounterText(context, total)),
                        additionalInfo: Text(formatBytes(context, total.total), style: TextStyle(color: secondary)),
                      ),
                  ],
                ),
                _section(
                  context,
                  footer: since == null ? null : trafficSinceText(context, since),
                  children: [
                    CupertinoListTile(
                      title: Text(t.resetStatistics, style: const TextStyle(color: CupertinoColors.destructiveRed)),
                      onTap: since == null ? null : () => _confirmReset(context),
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
