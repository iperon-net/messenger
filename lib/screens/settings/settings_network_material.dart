import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'settings_data_common.dart';

/// «Использование трафика» (Android): мобильная сеть / Wi-Fi, диаграмма и
/// отправлено / получено по категориям, сброс статистики.
class SettingsNetworkMaterial extends StatelessWidget {
  const SettingsNetworkMaterial({super.key});

  Widget _note(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    child: Text(
      text,
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );

  Widget _card(List<Widget> children) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(children: children),
  );

  Future<void> _confirmReset(BuildContext context) async {
    final t = context.t.screenSettingsData;
    final cubit = context.read<SettingsNetworkCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.resetTitle),
        content: Text(t.resetMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            child: Text(t.reset),
          ),
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
        final scheme = Theme.of(context).colorScheme;
        final muted = scheme.onSurfaceVariant;
        final usage = state.current;
        final total = state.total;
        final categories = [
          for (final category in models.TrafficCategory.values)
            if ((usage[category]?.total ?? 0) > 0) category,
        ];
        final since = state.since;
        Widget size(int bytes) => Text(
          formatBytes(context, bytes),
          style: TextStyle(fontSize: AppFontSizes.label, color: muted),
        );
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.networkUsage)),
          backgroundColor: scheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SegmentedButton<models.NetworkKind>(
                    segments: [
                      for (final network in models.NetworkKind.values)
                        ButtonSegment(value: network, label: Text(networkTitle(context.t, network))),
                    ],
                    selected: {state.network},
                    showSelectedIcon: false,
                    onSelectionChanged: (selected) => cubit.setNetwork(selected.first),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Center(
                    child: UsageDonut(
                      segments: trafficSegments(usage),
                      emptyColor: scheme.surfaceContainerHighest,
                      center: state.status != Status.success
                          ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
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
                                  style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                _card([
                  if (categories.isEmpty)
                    ListTile(
                      title: Text(t.noTraffic, style: TextStyle(color: muted)),
                    ),
                  for (final category in categories)
                    ListTile(
                      leading: UsageDot(trafficCategoryColor(category)),
                      minLeadingWidth: 12,
                      title: Text(trafficCategoryTitle(context.t, category)),
                      subtitle: Text(trafficCounterText(context, usage[category]!)),
                      trailing: size(usage[category]!.total),
                    ),
                  if (categories.isNotEmpty)
                    ListTile(
                      title: Text(t.total, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(trafficCounterText(context, total)),
                      trailing: size(total.total),
                    ),
                ]),
                _note(context, t.networkNote),
                const SizedBox(height: 8),
                _card([
                  ListTile(
                    title: Text(t.resetStatistics, style: TextStyle(color: since == null ? muted : scheme.error)),
                    onTap: since == null ? null : () => _confirmReset(context),
                  ),
                ]),
                if (since != null) _note(context, trafficSinceText(context, since)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
