import 'package:cupertino_ui/cupertino_ui.dart';
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
import 'chat_actions_cupertino.dart';
import 'chat_swipe_actions.dart';

/// Вкладка «Чаты» (iOS). Сверху поиск и табы-папки в стиле сегмент-контрола
/// «Звонков»; папки листаются свайпом влево/вправо (`PageView`), бегунок таба
/// едет за пальцем. Действия над чатом — по long-press (свайп занят папками).
/// Пока работает только в UX-демо (флаг на экране «Разработчик»), см.
/// docs/plans/chats-groups-channels.md.
class ChatsCupertino extends StatefulWidget {
  const ChatsCupertino({super.key});

  @override
  State<ChatsCupertino> createState() => _ChatsCupertino();
}

class _ChatsCupertino extends State<ChatsCupertino> with SearchHideOnScroll {
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
    return BlocListener<CommonCubit, CommonState>(
      // Тумблеры «Демо чатов» / «Серверные чаты» могли переключиться, пока вкладка жива.
      listenWhen: (previous, current) =>
          previous.settingsDevice.chatsDemo != current.settingsDevice.chatsDemo ||
          previous.settingsDevice.chatsServer != current.settingsDevice.chatsServer,
      listener: (context, state) => context.read<ChatsCubit>().setDemo(state.settingsDevice.chatsDemo),
      child: CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.appBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            backgroundColor: ThemesCupertino.appBackground,
            middle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CommonCubit, CommonState>(
                  builder: (context, stateCommon) {
                    if (stateCommon.settingsDevice.passcode.isNotEmpty) {
                      return GestureDetector(
                        onTap: () async => await context.read<CommonCubit>().forceLock(biometrics: false),
                        child: FaIcon(
                          FontAwesomeIcons.lockOpen,
                          size: 16,
                          color: CupertinoTheme.brightnessOf(context) == Brightness.dark ? CupertinoColors.white : CupertinoColors.black,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(width: 10),
                ConnectionTitle(title: context.t.screenChats.chats),
              ],
            ),
            // «Новое» — пока только в демо (настоящих чатов ещё нет).
            trailing: BlocSelector<ChatsCubit, ChatsState, bool>(
              selector: (state) => state.demo,
              builder: (context, demo) {
                if (!demo) return const SizedBox.shrink();
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.push('/chats/new'),
                  child: const Icon(CupertinoIcons.square_pencil, size: 25),
                );
              },
            ),
          ),
        ),
        child: SafeArea(
          // Шапка (поиск, баннер, табы) поверх списков: поиск уезжает вместе со
          // списком, как в Telegram (см. SearchHideOnScroll).
          child: searchHideOnScrollBody(
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
            background: ThemesCupertino.appBackground.resolveFrom(context),
            // Поле поиска — вне BlocBuilder, чтобы не пересоздаваться на каждый
            // emit (иначе на iOS сбрасывается область композиции клавиатуры).
            search: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: SearchFieldCupertino(
                controller: searchController,
                focusNode: searchFocus,
                placeholder: context.t.screenChats.search,
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
                  return PermissionBannerCupertino(
                    icon: HugeIcons.strokeRoundedNotification03,
                    title: context.t.screenChats.notificationPermissionTitle,
                    message: context.t.screenChats.notificationPermissionMessage,
                    actionLabel: context.t.screenChats.allowAccess,
                    onAction: () => context.read<ChatsCubit>().requestNotificationPermission(),
                    onDismiss: () => context.read<ChatsCubit>().dismissNotificationsBanner(),
                  );
                },
              ),
              BlocBuilder<ChatsCubit, ChatsState>(
                builder: (context, state) {
                  if (state.folders.length < 2) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: ChatFolderTabsCupertino(
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
                      contextActions: (index) =>
                          folderContextActionsCupertino(context, state.folders[index], _folderTitle(context, state.folders[index])),
                    ),
                  );
                },
              ),
            ],
          ),
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

    final divider = Container(
      margin: const EdgeInsetsDirectional.only(start: ChatTileCupertino.dividerIndent),
      height: 0.5,
      color: CupertinoColors.separator.resolveFrom(context),
    );
    final offset = archived.isEmpty ? 0 : 1;

    // Свой контроллер (и позиция прокрутки) у каждой папки; сверху отступ под
    // шапку — строки проезжают под ней.
    return searchListView(
      key: PageStorageKey('chats_folder_${folder.id}'),
      listKey: folder.id,
      itemCount: chats.length + offset,
      separatorBuilder: (_, _) => divider,
      itemBuilder: (context, index) {
        if (index < offset) return _ArchiveTileCupertino(archived: archived, onTap: () => context.push('/chats/archive'));
        final chat = chats[index - offset];
        return ChatSwipeActions(
          key: ValueKey(chat.id),
          chat: chat,
          // Несколько папок — свайп листает их (действия — по удержанию).
          enabled: state.folders.length < 2,
          confirmDelete: () => confirmDeleteChatCupertino(context, chat),
          child: ChatContextMenuCupertino(chat: chat, onTap: () => context.push('/chats/chat/${chat.id}')),
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
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
        ),
      ),
    );
  }
}

/// Строка «Архив» вверху «Всех чатов» (как в Telegram): серая иконка, список
/// названий архивных чатов и серый бейдж непрочитанных.
class _ArchiveTileCupertino extends StatelessWidget {
  final List<models.Chat> archived;
  final VoidCallback onTap;

  const _ArchiveTileCupertino({required this.archived, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final grey = CupertinoColors.systemGrey.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final unread = archived.where((c) => c.hasUnread).length;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: grey, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.boxArchive, size: 22, color: CupertinoColors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t.screenChats.archive,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    archived.map((c) => ChatTileContent.title(context.t, c)).join(', '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: secondary),
                  ),
                ],
              ),
            ),
            if (unread > 0)
              Container(
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: grey, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '$unread',
                  style: const TextStyle(fontSize: 14, color: CupertinoColors.white, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
