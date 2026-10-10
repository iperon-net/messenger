import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../models.dart' as models;
import 'chat_actions_material.dart';
import 'chat_swipe_actions.dart';

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

class _ChatsMaterial extends State<ChatsMaterial> with SearchHideOnScroll {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: context.read<ChatsCubit>().state.folderIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return BlocListener<CommonCubit, CommonState>(
      // Тумблеры «Демо чатов» / «Серверные чаты» могли переключиться, пока вкладка жива.
      listenWhen: (previous, current) =>
          previous.settingsDevice.chatsDemo != current.settingsDevice.chatsDemo ||
          previous.settingsDevice.chatsServer != current.settingsDevice.chatsServer,
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
          // «Новое» — карандаш справа от заголовка; пока только в демо
          // (настоящих чатов ещё нет).
          actions: [
            BlocSelector<ChatsCubit, ChatsState, bool>(
              selector: (state) => state.demo,
              builder: (context, demo) {
                if (!demo) return const SizedBox.shrink();
                return IconButton(
                  tooltip: context.t.screenNewChat.title,
                  onPressed: () => context.push('/chats/new'),
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
                );
              },
            ),
          ],
        ),
        // Шапка (поиск, баннер, табы) поверх списков: поиск уезжает вместе со
        // списком, как в Telegram (см. SearchHideOnScroll).
        body: searchHideOnScrollBody(
          body: BlocConsumer<ChatsCubit, ChatsState>(
            // Папку удалили/список сменился — держим PageView на активной папке.
            listenWhen: (previous, current) => previous.folderIndex != current.folderIndex || previous.folders != current.folders,
            listener: (context, state) {
              if (!_pageController.hasClients) return;
              if (_pageController.page?.round() != state.folderIndex) _pageController.jumpToPage(state.folderIndex);
            },
            builder: (context, state) {
              if (state.folders.isEmpty) return _empty(context, context.t.screenChats.empty);
              // Открытая свайпом строка закрывается при прокрутке и тапе мимо.
              return SlidableAutoCloseBehavior(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: state.folders.length,
                  onPageChanged: (index) {
                    onSearchListChanged(state.folders[index].id);
                    context.read<ChatsCubit>().setFolderIndex(index);
                  },
                  itemBuilder: (context, index) => _folderPage(context, state, state.folders[index]),
                ),
              );
            },
          ),
          background: background,
          // Поле поиска — вне BlocBuilder, чтобы не терять фокус на каждый emit.
          search: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: SearchFieldMaterial(
              controller: searchController,
              focusNode: searchFocus,
              hintText: context.t.screenChats.search,
              onChanged: (value) => context.read<ChatsCubit>().search(value),
            ),
          ),
          header: [
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
            BlocBuilder<ChatsCubit, ChatsState>(
              builder: (context, state) {
                if (state.folders.length < 2) return const SizedBox.shrink();
                return Padding(
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
                    onTap: (index) =>
                        _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic),
                    onLongPress: (index) =>
                        showFolderActionsMaterial(context, state.folders[index], _folderTitle(context, state.folders[index])),
                  ),
                );
              },
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
      return _empty(context, state.query.isEmpty ? context.t.screenChats.emptyFolder : context.t.screenChats.empty, folder: folder);
    }
    final offset = archived.isEmpty ? 0 : 1;

    // Свой контроллер (и позиция прокрутки) у каждой папки; сверху отступ под
    // шапку — строки проезжают под ней.
    return searchListView(
      key: PageStorageKey('chats_folder_${folder.id}'),
      listKey: folder.id,
      itemCount: chats.length + offset,
      itemBuilder: (context, index) {
        if (index < offset) return _ArchiveTileMaterial(archived: archived, onTap: () => context.push('/chats/archive'));
        final chat = chats[index - offset];
        return ChatSwipeActions(
          key: ValueKey(chat.id),
          chat: chat,
          // Несколько папок — свайп листает их (действия — по удержанию).
          enabled: state.folders.length < 2,
          confirmDelete: () => confirmDeleteChatMaterial(context, chat),
          child: ChatTileMaterial(
            chat: chat,
            onTap: () => context.push('/chats/chat/${chat.id}'),
            onLongPress: () => showChatActionsMaterial(context, chat),
          ),
        );
      },
    );
  }

  /// Пусто — тоже прокручиваемый список папки (см. searchListView): иначе
  /// спрятанный поиск всплывал бы при переходе в пустую папку.
  Widget _empty(BuildContext context, String text, {models.ChatFolder? folder}) {
    return searchListView(
      key: folder == null ? null : PageStorageKey('chats_folder_${folder.id}'),
      listKey: folder?.id ?? '',
      empty: Padding(
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
