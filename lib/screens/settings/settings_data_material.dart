import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../chats/media_files.dart';
import '../../cubit.dart';
import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// «Данные и память»: «Использование памяти» и «Использование трафика».
class SettingsDataMaterial extends StatelessWidget {
  const SettingsDataMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.dataAndStorage)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                t.usage,
                style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  MaterialListTileIcon(
                    title: Text(t.storageUsage),
                    color: const Color(0xFF34C759),
                    icon: FontAwesomeIcons.chartPie,
                    onTab: () async => context.push('/settings/data/storage'),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(t.networkUsage),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.chartSimple,
                    onTab: () async => context.push('/settings/data/network'),
                    isTrailing: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Text(
                t.storageNote,
                style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
              ),
            ),
            if (Platform.isMacOS) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Text(
                  t.downloads,
                  style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                ),
              ),
              const Card(margin: EdgeInsets.symmetric(horizontal: 12), child: _DownloadsDirTile()),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Text(
                  t.downloadsNote,
                  style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// macOS: «Папка для загрузок» — путь (домашняя папка — «~»), тап — выбрать
/// другую, ↺ — вернуть «Загрузки/Iperon».
class _DownloadsDirTile extends StatelessWidget {
  const _DownloadsDirTile();

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    final dir = context.select<CommonCubit, String>((cubit) => cubit.state.settingsDevice.downloadsDir);
    final home = Platform.environment['HOME'] ?? '';
    final shown = dir.isEmpty
        ? t.downloadsDefault
        : home.isNotEmpty && dir.startsWith('$home/')
        ? '~${dir.substring(home.length)}'
        : dir;
    return ListTile(
      title: Text(t.downloadsDir),
      subtitle: Text(shown, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: dir.isEmpty
          ? null
          : IconButton(
              tooltip: t.downloadsReset,
              icon: const Icon(Icons.restart_alt),
              onPressed: () => context.read<CommonCubit>().setDownloadsDir(''),
            ),
      onTap: () async {
        final cubit = context.read<CommonCubit>();
        final picked = await FilePicker.getDirectoryPath(
          dialogTitle: t.downloadsDir,
          initialDirectory: dir.isNotEmpty ? dir : await MediaFiles.defaultDownloadsDir(),
        );
        if (picked != null && picked.isNotEmpty) await cubit.setDownloadsDir(picked);
      },
    );
  }
}
