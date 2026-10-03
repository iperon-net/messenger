import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../models.dart' as models;
import 'chat_actions_material.dart';

/// Вкладка «Чаты» (Android). Сверху поиск и табы-папки в стиле
/// `SegmentedButton` «Звонков»; папки листаются свайпом влево/вправо
/// (`PageView`), бегунок таба едет за пальцем. Действия над чатом — по
/// long-press (свайп занят папками). Пока работает только в UX-демо (флаг на
/// экране «Разработчик»), см. docs/plans/chats-groups-channels.md.
class ChatsMaterial extends StatefulWidget {
  const ChatsMaterial({super.key});

  @override
  State<ChatsMaterial> createState() => _ChatsMaterial();
}

class _ChatsMaterial extends State<ChatsMaterial> {
  final _searchController = TextEditingController();
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: context.read<ChatsCubit>().state.folderIndex);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return BlocListener<CommonCubit, CommonState>(
      // Тумблер «Демо чатов» мог переключиться, пока вкладка жива.
      listenWhen: (previous, current) => previous.settingsDevice.chatsDemo != current.settingsDevice.chatsDemo,
      listener: (context, state) => context.read<ChatsCubit>().setDemo(state.settingsDevice.chatsDemo),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          title: ConnectionTitle(
            title: context.t.screenChats.chats,
            leading: BlocBuilder<CommonCubit, CommonState>(
              builder: (context, stateCommon) {
                if (stateCommon.settingsDevice.passcode.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () async => await context.read<CommonCubit>().forceLock(biometrics: false),
                      child: const FaIcon(FontAwesomeIcons.lockOpen, size: 18),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        body: Column(
          children: [
            // Поле поиска — вне BlocBuilder, чтобы не терять фокус на каждый emit.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: SearchFieldMaterial(
                controller: _searchController,
                hintText: context.t.screenChats.search,
                onChanged: (value) => context.read<ChatsCubit>().search(value),
              ),
            ),
            // Мягкий баннер-объяснение о разрешении на уведомления. Виден, только
            // пока разрешения нет и пользователь его не закрыл.
            BlocSelector<ChatsCubit, ChatsState, bool>(
              selector: (state) => state.showNotificationsBanner,
              builder: (context, show) {
                if (!show) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PermissionBannerMaterial(
                    icon: HugeIcons.strokeRoundedNotification03,
                    title: context.t.screenChats.notificationPermissionTitle,
                    message: context.t.screenChats.notificationPermissionMessage,
                    actionLabel: context.t.screenChats.allowAccess,
                    onAction: () => context.read<ChatsCubit>().requestNotificationPermission(),
                    onDismiss: () => context.read<ChatsCubit>().dismissNotificationsBanner(),
                    dismissTooltip: context.t.common.notNow,
                  ),
                );
              },
            ),
            Expanded(
              child: BlocConsumer<ChatsCubit, ChatsState>(
                // Папку удалили/список сменился — держим PageView на активной папке.
                listenWhen: (previous, current) => previous.folderIndex != current.folderIndex || previous.folders != current.folders,
                listener: (context, state) {
                  if (!_pageController.hasClients) return;
                  if (_pageController.page?.round() != state.folderIndex) _pageController.jumpToPage(state.folderIndex);
                },
                builder: (context, state) {
                  if (state.folders.isEmpty) return _empty(context, context.t.screenChats.empty);
                  return Column(
                    children: [
                      if (state.folders.length > 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: ChatFolderTabsMaterial(
                            controller: _pageController,
                            selectedIndex: state.folderIndex,
                            tabs: [
                              for (final folder in state.folders)
                                ChatFolderTab(
                                  title: _folderTitle(context, folder),
                                  badge: state.unreadOf(folder).count,
                                  badgeMuted: state.unreadOf(folder).muted,
                                ),
                            ],
                            onTap: (index) => _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                            ),
                            onLongPress: (index) =>
                                showFolderActionsMaterial(context, state.folders[index], _folderTitle(context, state.folders[index])),
                          ),
                        ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: state.folders.length,
                          onPageChanged: (index) => context.read<ChatsCubit>().setFolderIndex(index),
                          itemBuilder: (context, index) => _folderPage(context, state, state.folders[index]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _folderTitle(BuildContext context, models.ChatFolder folder) => folder.isAll ? context.t.screenChats.allFolder : folder.title;

  Widget _folderPage(BuildContext context, ChatsState state, models.ChatFolder folder) {
    final chats = state.chatsOf(folder);
    final archived = folder.isAll && state.query.isEmpty ? state.archived : const <models.Chat>[];
    if (chats.isEmpty && archived.isEmpty) {
      return _empty(context, state.query.isEmpty ? context.t.screenChats.emptyFolder : context.t.screenChats.empty);
    }
    final offset = archived.isEmpty ? 0 : 1;

    return ListView.builder(
      // Своя позиция прокрутки у каждой папки.
      key: PageStorageKey('chats_folder_${folder.id}'),
      itemCount: chats.length + offset,
      itemBuilder: (context, index) {
        if (index < offset) return _ArchiveTileMaterial(archived: archived, onTap: () => context.push('/chats/archive'));
        final chat = chats[index - offset];
        return ChatTileMaterial(
          key: ValueKey(chat.id),
          chat: chat,
          // Окно чата — следующий шаг демо.
          onTap: () {},
          onLongPress: () => showChatActionsMaterial(context, chat),
        );
      },
    );
  }

  Widget _empty(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

/// Строка «Архив» вверху «Всех чатов» (как в Telegram): серая иконка, список
/// названий архивных чатов и серый бейдж непрочитанных.
class _ArchiveTileMaterial extends StatelessWidget {
  final List<models.Chat> archived;
  final VoidCallback onTap;

  const _ArchiveTileMaterial({required this.archived, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unread = archived.where((c) => c.hasUnread).length;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 27,
        backgroundColor: scheme.outline,
        child: FaIcon(FontAwesomeIcons.boxArchive, size: 20, color: scheme.surface),
      ),
      title: Text(context.t.screenChats.archive, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(archived.map((c) => ChatTileContent.title(context.t, c)).join(', '), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: unread > 0
          ? Container(
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(color: scheme.outline, borderRadius: BorderRadius.circular(11)),
              // Не `alignment` у Container: в trailing ListTile он растянулся бы на
              // всю ширину плитки (assert «Trailing widget consumes the entire tile
              // width»). Center с factor = 1 центрирует, не растягиваясь.
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  '$unread',
                  style: TextStyle(fontSize: 13, color: scheme.surface, fontWeight: FontWeight.w600),
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
