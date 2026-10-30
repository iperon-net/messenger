import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../storage_usage.dart';
import '../../themes.dart';
import 'settings_data_common.dart';

/// «Использование памяти» (iOS): диаграмма, типы файлов с выбором к очистке,
/// «Хранить медиа», предел кэша, файлы по чатам и прочее.
class SettingsStorageCupertino extends StatelessWidget {
  const SettingsStorageCupertino({super.key});

  CupertinoListSection _section(BuildContext context, {String? header, String? footer, required List<Widget> children}) {
    return CupertinoListSection.insetGrouped(
      header: header == null
          ? null
          : Text(
              header,
              style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
            ),
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

  Future<void> _confirmClear(BuildContext context) async {
    final t = context.t.screenSettingsData;
    final cubit = context.read<SettingsStorageCubit>();
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.clearCacheTitle),
        content: Text(t.clearCacheMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.clear)),
        ],
      ),
    );
    if (ok == true) await cubit.clearSelected();
  }

  /// Строка с размером; [onClear] — тап открывает меню «Очистить · размер».
  Widget _sizeRow(
    BuildContext context, {
    Widget? leading,
    required String title,
    required int bytes,
    Future<void> Function()? onClear,
    bool busy = false,
  }) {
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final size = Text(formatBytes(context, bytes), style: TextStyle(color: secondary));
    if (onClear == null || bytes == 0) {
      return CupertinoListTile(leading: leading, title: Text(title), additionalInfo: size);
    }
    return CupertinoMenuAnchor(
      menuChildren: [
        CupertinoMenuItem(
          isDestructiveAction: true,
          onPressed: busy ? null : onClear,
          child: Text('${context.t.screenSettingsData.clear} · ${formatBytes(context, bytes)}'),
        ),
      ],
      builder: (context, controller, child) => CupertinoListTile(
        leading: leading,
        title: Text(title, overflow: TextOverflow.ellipsis),
        additionalInfo: size,
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }

  Widget _picker<T>(
    BuildContext context, {
    required String title,
    required T value,
    required List<T> items,
    required String Function(T value) label,
    required void Function(T value) onSelected,
  }) {
    return CupertinoListTile(
      title: Text(title),
      trailing: CupertinoMenuAnchor(
        builder: (context, controller, child) => CupertinoButton(
          padding: EdgeInsets.zero,
          // Короткое значение («∞») — по правому краю, как остальные, а не по
          // центру минимальной ширины кнопки.
          alignment: Alignment.centerRight,
          onPressed: () => controller.isOpen ? controller.close() : controller.open(),
          child: Text(label(value), style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
        ),
        menuChildren: [
          for (final item in items)
            CupertinoMenuItem(
              trailing: item == value ? const Icon(CupertinoIcons.check_mark) : null,
              onPressed: () => onSelected(item),
              child: Text(label(item)),
            ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, SettingsStorageState state) {
    final t = context.t.screenSettingsData;
    final report = state.report;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Center(
        child: UsageDonut(
          segments: report == null ? const [] : storageSegments(report),
          emptyColor: CupertinoColors.systemFill.resolveFrom(context),
          center: report == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const CupertinoActivityIndicator(),
                    Text(
                      t.calculating,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
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
                      style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _cacheSections(BuildContext context, SettingsStorageState state, models.StorageReport report) {
    final t = context.t.screenSettingsData;
    final cubit = context.read<SettingsStorageCubit>();
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final categories = [
      for (final category in models.StorageCategory.values)
        if ((report.byCategory[category] ?? 0) > 0) category,
    ];
    if (categories.isEmpty) {
      return [
        _section(
          context,
          children: [
            CupertinoListTile(
              title: Text(t.empty, style: TextStyle(color: secondary)),
            ),
          ],
        ),
      ];
    }
    final selectedBytes = state.selectedBytes;
    return [
      _section(
        context,
        footer: report.protectedBytes > 0 && state.selected.contains(models.StorageCategory.other) ? t.cacheNote : null,
        children: [
          for (final category in categories)
            CupertinoListTile(
              leading: Icon(
                state.selected.contains(category) ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                color: state.selected.contains(category)
                    ? storageCategoryColor(category)
                    : CupertinoColors.systemGrey3.resolveFrom(context),
              ),
              title: Text(storageCategoryTitle(context.t, category)),
              additionalInfo: Text(formatBytes(context, report.byCategory[category] ?? 0), style: TextStyle(color: secondary)),
              onTap: state.clearing ? null : () => cubit.toggle(category),
            ),
          CupertinoListTile(
            title: Center(
              child: state.clearing
                  ? const CupertinoActivityIndicator()
                  : Text(
                      selectedBytes > 0 ? t.clearCacheSize(size: formatBytes(context, selectedBytes)) : t.clearCache,
                      style: TextStyle(color: selectedBytes > 0 ? primary : secondary, fontWeight: FontWeight.w600),
                    ),
            ),
            onTap: state.clearing || selectedBytes == 0 ? null : () => _confirmClear(context),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    return BlocBuilder<SettingsStorageCubit, SettingsStorageState>(
      builder: (context, state) {
        final cubit = context.read<SettingsStorageCubit>();
        final report = state.report;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticallyImplyLeading: !context.isSplitPaneRoot,
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.storageUsage),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                _header(context, state),
                if (report != null) ..._cacheSections(context, state, report),
                _section(
                  context,
                  footer: t.keepMediaNote,
                  children: [
                    _picker<int>(
                      context,
                      title: t.keepMedia,
                      value: state.keepMediaDays,
                      items: StorageUsage.keepMediaOptions,
                      label: (days) => keepMediaLabel(context.t, days),
                      onSelected: cubit.setKeepMediaDays,
                    ),
                  ],
                ),
                _section(
                  context,
                  footer: t.maxCacheNote,
                  children: [
                    _picker<int>(
                      context,
                      title: t.maxCache,
                      value: state.maxCacheMB,
                      items: StorageUsage.maxCacheOptions,
                      label: (mb) => maxCacheLabel(context, mb),
                      onSelected: cubit.setMaxCacheMB,
                    ),
                  ],
                ),
                if (state.chats.isNotEmpty)
                  _section(
                    context,
                    header: t.chats,
                    children: [
                      for (final item in state.chats)
                        _sizeRow(
                          context,
                          leading: item.chat == null
                              ? null
                              : ChatAvatar(
                                  chat: item.chat!,
                                  accentColor: CupertinoTheme.of(context).primaryColor,
                                  accentForeground: ThemesCupertino.onAccent(context),
                                  size: 32,
                                ),
                          title: item.chat == null ? t.otherChats : ChatTileContent.title(context.t, item.chat!),
                          bytes: item.bytes,
                          busy: state.clearing,
                          onClear: () => cubit.clearChat(item),
                        ),
                    ],
                  ),
                if (report != null)
                  _section(
                    context,
                    header: t.service,
                    footer: t.databaseNote,
                    children: [
                      _sizeRow(context, title: t.database, bytes: report.database),
                      if (report.emoji > 0)
                        _sizeRow(context, title: t.emoji, bytes: report.emoji, busy: state.clearing, onClear: cubit.clearEmoji),
                      if (report.temp > 0)
                        _sizeRow(context, title: t.temp, bytes: report.temp, busy: state.clearing, onClear: cubit.clearTemp),
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
