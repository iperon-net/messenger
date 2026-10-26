import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../storage_usage.dart';
import '../../themes.dart';
import 'settings_data_common.dart';

/// «Использование памяти» (Android): диаграмма, типы файлов с выбором к
/// очистке, «Хранить медиа», предел кэша, файлы по чатам и прочее.
class SettingsStorageMaterial extends StatelessWidget {
  const SettingsStorageMaterial({super.key});

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
    child: Text(
      text,
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );

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

  /// Подтверждение очистки; `true` — очистить.
  Future<bool> _confirm(BuildContext context, {required String title, String? message}) async {
    final t = context.t.screenSettingsData;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            child: Text(t.clear),
          ),
        ],
      ),
    );
    return ok == true;
  }

  /// Строка с размером; [onClear] — тап спрашивает и очищает.
  Widget _sizeRow(
    BuildContext context, {
    Widget? leading,
    required String title,
    required int bytes,
    Future<void> Function()? onClear,
    bool busy = false,
  }) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListTile(
      leading: leading,
      title: Text(title, overflow: TextOverflow.ellipsis),
      trailing: Text(
        formatBytes(context, bytes),
        style: TextStyle(fontSize: AppFontSizes.label, color: muted),
      ),
      onTap: onClear == null || bytes == 0 || busy
          ? null
          : () async {
              final message = context.t.screenSettingsData.clearCacheMessage;
              if (await _confirm(
                context,
                title: context.t.screenSettingsData.clearChatTitle(title: title),
                message: message,
              )) {
                await onClear();
              }
            },
    );
  }

  Widget _donut(BuildContext context, SettingsStorageState state) {
    final t = context.t.screenSettingsData;
    final scheme = Theme.of(context).colorScheme;
    final report = state.report;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: UsageDonut(
          segments: report == null ? const [] : storageSegments(report),
          emptyColor: scheme.surfaceContainerHighest,
          center: report == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
                    Text(
                      t.calculating,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: scheme.onSurfaceVariant),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        formatBytes(context, report.total),
                        style: TextStyle(fontSize: AppFontSizes.emphasisLarge, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      t.onDevice,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _cache(BuildContext context, SettingsStorageState state, models.StorageReport report) {
    final t = context.t.screenSettingsData;
    final cubit = context.read<SettingsStorageCubit>();
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final categories = [
      for (final category in models.StorageCategory.values)
        if ((report.byCategory[category] ?? 0) > 0) category,
    ];
    if (categories.isEmpty) {
      return [
        const SizedBox(height: 8),
        _card([
          ListTile(
            title: Text(t.empty, style: TextStyle(color: muted)),
          ),
        ]),
      ];
    }
    final selectedBytes = state.selectedBytes;
    return [
      const SizedBox(height: 8),
      _card([
        for (final category in categories)
          CheckboxListTile(
            value: state.selected.contains(category),
            onChanged: state.clearing ? null : (_) => cubit.toggle(category),
            activeColor: storageCategoryColor(category),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(storageCategoryTitle(context.t, category)),
            secondary: Text(
              formatBytes(context, report.byCategory[category] ?? 0),
              style: TextStyle(fontSize: AppFontSizes.label, color: muted),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.clearing || selectedBytes == 0
                  ? null
                  : () async {
                      if (await _confirm(context, title: t.clearCacheTitle, message: t.clearCacheMessage)) {
                        await cubit.clearSelected();
                      }
                    },
              child: state.clearing
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(selectedBytes > 0 ? t.clearCacheSize(size: formatBytes(context, selectedBytes)) : t.clearCache),
            ),
          ),
        ),
      ]),
      if (report.protectedBytes > 0 && state.selected.contains(models.StorageCategory.other)) _note(context, t.cacheNote),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    return BlocBuilder<SettingsStorageCubit, SettingsStorageState>(
      builder: (context, state) {
        final cubit = context.read<SettingsStorageCubit>();
        final scheme = Theme.of(context).colorScheme;
        final report = state.report;
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.storageUsage)),
          backgroundColor: scheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                _donut(context, state),
                if (report != null) ..._cache(context, state, report),
                const SizedBox(height: 16),
                _card([
                  ListTile(
                    title: Text(t.keepMedia),
                    trailing: MaterialInlineDropdown<int>(
                      value: state.keepMediaDays,
                      items: StorageUsage.keepMediaOptions,
                      labelBuilder: (days) => keepMediaLabel(context.t, days),
                      onSelected: cubit.setKeepMediaDays,
                    ),
                  ),
                ]),
                _note(context, t.keepMediaNote),
                const SizedBox(height: 8),
                _card([
                  ListTile(
                    title: Text(t.maxCache),
                    trailing: MaterialInlineDropdown<int>(
                      value: state.maxCacheMB,
                      items: StorageUsage.maxCacheOptions,
                      labelBuilder: (mb) => maxCacheLabel(context, mb),
                      onSelected: cubit.setMaxCacheMB,
                    ),
                  ),
                ]),
                _note(context, t.maxCacheNote),
                if (state.chats.isNotEmpty) ...[
                  _header(context, t.chats),
                  _card([
                    for (final item in state.chats)
                      _sizeRow(
                        context,
                        leading: item.chat == null
                            ? null
                            : ChatAvatar(chat: item.chat!, accentColor: scheme.primary, accentForeground: scheme.onPrimary, size: 40),
                        title: item.chat == null ? t.otherChats : ChatTileContent.title(context.t, item.chat!),
                        bytes: item.bytes,
                        busy: state.clearing,
                        onClear: () => cubit.clearChat(item),
                      ),
                  ]),
                ],
                if (report != null) ...[
                  _header(context, t.service),
                  _card([
                    _sizeRow(context, title: t.database, bytes: report.database),
                    if (report.emoji > 0)
                      _sizeRow(context, title: t.emoji, bytes: report.emoji, busy: state.clearing, onClear: cubit.clearEmoji),
                    if (report.temp > 0)
                      _sizeRow(context, title: t.temp, bytes: report.temp, busy: state.clearing, onClear: cubit.clearTemp),
                  ]),
                  _note(context, t.databaseNote),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
