import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_folder_edit_cupertino.dart';
import 'chat_folders_common.dart';
import 'chats_new_cupertino.dart';

/// «Папки» (iOS): Настройки → Папки или «Изменить папки» / «Изменить порядок»
/// по удержанию таба. Полноэкранно поверх таб-бара.
Future<void> showChatFoldersCupertino(BuildContext context) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context, rootNavigator: true).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider(
        create: (_) => ChatFoldersCubit()..initialization(demo: demo),
        child: const ChatFoldersCupertino(),
      ),
    ),
  );
}

/// «Мои папки»: создать, «Все чаты» (не меняется), папки пользователя — тап
/// открывает редактор, ≡ — перетащить; ниже рекомендованные папки (добавить
/// одной кнопкой). Лимит — [models.chatFoldersLimit] вместе с «Все чаты».
class ChatFoldersCupertino extends StatelessWidget {
  const ChatFoldersCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.screenChatFolders;
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final separator = CupertinoColors.separator.resolveFrom(context);
    final action = ThemesCupertino.actionColor(context);

    // Ведущая ячейка 40 у всех строк «Мои папки» — значки в одну колонку (как
    // в редакторе папки).
    Widget tile({required Widget leading, required Widget title, Widget? subtitle, Widget? trailing, VoidCallback? onTap}) =>
        CupertinoListTile(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leadingSize: 40,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
        );

    Widget folderIcon(FaIconData icon) => Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: const Color(0xFF00A3D9), borderRadius: BorderRadius.circular(7)),
      alignment: Alignment.center,
      child: FaIcon(icon, size: 15, color: const Color(0xFFFFFFFF)),
    );

    Widget section({String? header, String? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    return BlocBuilder<ChatFoldersCubit, ChatFoldersState>(
      builder: (context, state) {
        final cubit = context.read<ChatFoldersCubit>();
        final folders = state.userFolders;
        final all = state.folders.where((f) => f.isAll).firstOrNull;

        Widget folderRow(int index, models.ChatFolder folder) => Column(
          key: ValueKey(folder.id),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0) Container(height: 0.5, margin: const EdgeInsets.only(left: 72), color: separator),
            tile(
              leading: folderIcon(FontAwesomeIcons.solidFolder),
              title: Text(folder.title),
              subtitle: Text(chatFolderSubtitle(t, state.chatsCount(folder))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CupertinoListTileChevron(),
                  ReorderableDragStartListener(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(CupertinoIcons.line_horizontal_3, color: CupertinoColors.systemGrey.resolveFrom(context)),
                    ),
                  ),
                ],
              ),
              onTap: () => showChatFolderEditCupertino(context, cubit: cubit, folder: folder),
            ),
          ],
        );

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(s.folders),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.solidFolderOpen, size: 48, color: primary),
                      const SizedBox(height: 12),
                      Text(
                        s.intro,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                      ),
                    ],
                  ),
                ),
                section(
                  header: s.myFolders,
                  footer: state.canCreate ? s.reorderFooter(n: models.chatFoldersLimit) : s.limitReached(n: models.chatFoldersLimit),
                  children: [
                    if (state.canCreate)
                      tile(
                        leading: Icon(CupertinoIcons.add_circled, color: action, size: 28),
                        title: Text(
                          s.createFolder,
                          style: TextStyle(color: action, fontSize: AppFontSizes.body),
                        ),
                        onTap: () => showChatFolderEditCupertino(context, cubit: cubit),
                      ),
                    if (all != null)
                      tile(
                        leading: folderIcon(FontAwesomeIcons.solidComments),
                        title: Text(chatFolderTitle(t, all)),
                        subtitle: Text(s.allChatsSubtitle),
                      ),
                    if (folders.isNotEmpty)
                      ReorderableList(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: folders.length,
                        onReorderItem: cubit.reorder,
                        proxyDecorator: (child, index, animation) => Container(
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12)],
                          ),
                          child: child,
                        ),
                        itemBuilder: (context, index) => folderRow(index, folders[index]),
                      ),
                  ],
                ),
                if (state.canCreate && state.presets.isNotEmpty)
                  section(
                    header: s.recommended,
                    children: [
                      for (final preset in state.presets)
                        CupertinoListTile(
                          title: Text(chatFolderPresetTitle(t, preset)),
                          subtitle: Text(chatFolderPresetAbout(t, preset)),
                          trailing: CupertinoButton.tinted(
                            sizeStyle: CupertinoButtonSize.small,
                            onPressed: () => cubit.addPreset(preset, chatFolderPresetTitle(t, preset)),
                            child: Text(s.add, style: TextStyle(color: action)),
                          ),
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
