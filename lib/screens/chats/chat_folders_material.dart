import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_folder_edit_material.dart';
import 'chat_folders_common.dart';
import 'chats_new_material.dart';

/// «Папки» (Android): Настройки → Папки или «Изменить папки» / «Изменить
/// порядок» по удержанию таба. Полноэкранно поверх нижней навигации.
Future<void> showChatFoldersMaterial(BuildContext context) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context, rootNavigator: true).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatFoldersCubit()..initialization(demo: demo),
        child: const ChatFoldersMaterial(),
      ),
    ),
  );
}

/// «Мои папки»: создать, «Все чаты» (не меняется), папки пользователя — тап
/// открывает редактор, ≡ — перетащить; ниже рекомендованные папки (добавить
/// одной кнопкой). Лимит — [models.chatFoldersLimit] вместе с «Все чаты».
class ChatFoldersMaterial extends StatelessWidget {
  const ChatFoldersMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.screenChatFolders;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );

    return BlocBuilder<ChatFoldersCubit, ChatFoldersState>(
      builder: (context, state) {
        final cubit = context.read<ChatFoldersCubit>();
        final folders = state.userFolders;
        final all = state.folders.where((f) => f.isAll).firstOrNull;

        Widget folderRow(int index, models.ChatFolder folder) => ListTile(
          key: ValueKey(folder.id),
          title: Text(folder.title),
          subtitle: Text(chatFolderSubtitle(t, state.chatsCount(folder))),
          trailing: ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.drag_handle, color: scheme.onSurfaceVariant),
            ),
          ),
          onTap: () => showChatFolderEditMaterial(context, cubit: cubit, folder: folder),
        );

        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(s.folders)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.solidFolderOpen, size: 48, color: scheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        s.intro,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: AppFontSizes.caption, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                createHeaderMaterial(context, s.myFolders),
                card([
                  if (state.canCreate)
                    ListTile(
                      leading: Icon(Icons.create_new_folder_outlined, color: scheme.primary),
                      title: Text(s.createFolder, style: TextStyle(color: scheme.primary)),
                      onTap: () => showChatFolderEditMaterial(context, cubit: cubit),
                    ),
                  if (all != null) ListTile(title: Text(chatFolderTitle(t, all)), subtitle: Text(s.allChatsSubtitle)),
                  if (folders.isNotEmpty)
                    ReorderableList(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: folders.length,
                      onReorderItem: cubit.reorder,
                      // Перетаскиваемая строка рисуется в оверлее — вне Card,
                      // поэтому свой Material (фон и тень).
                      proxyDecorator: (child, index, animation) => Material(
                        elevation: 6,
                        color: theme.cardTheme.color ?? scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        child: child,
                      ),
                      itemBuilder: (context, index) => folderRow(index, folders[index]),
                    ),
                ]),
                createNoteMaterial(
                  context,
                  state.canCreate ? s.reorderFooter(n: models.chatFoldersLimit) : s.limitReached(n: models.chatFoldersLimit),
                ),
                if (state.canCreate && state.presets.isNotEmpty) ...[
                  createHeaderMaterial(context, s.recommended),
                  card([
                    for (final preset in state.presets)
                      ListTile(
                        title: Text(chatFolderPresetTitle(t, preset)),
                        subtitle: Text(chatFolderPresetAbout(t, preset)),
                        trailing: FilledButton.tonal(
                          onPressed: () => cubit.addPreset(preset, chatFolderPresetTitle(t, preset)),
                          child: Text(s.add),
                        ),
                      ),
                  ]),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
