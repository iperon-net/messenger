import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../themes.dart';
import '../../utils.dart';
import '../../i18n/translations.g.dart';
import '../../platform.dart';
import '../../chats/users_search.dart';
import '../chats/users_search_list_material.dart';

/// Экран «Контакты» (Android): найденные в Iperon + приглашения. Приватный поиск
/// через OPRF (см. ContactsCubit).
class ContactsMaterial extends StatefulWidget {
  const ContactsMaterial({super.key});

  @override
  State<ContactsMaterial> createState() => _ContactsMaterialState();
}

class _ContactsMaterialState extends State<ContactsMaterial> with SearchHideOnScroll {
  @override
  void initState() {
    super.initState();
    // Первый показ вкладки — осознанный момент запросить доступ и запустить поиск
    // (если фоновая дозагрузка на shell ещё не стартовала при уже выданном доступе).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ContactsCubit>().discoverOnFirstView();
    });
  }

  bool _matchesQuery(ContactItem item, String query) {
    if (query.isEmpty) return true;
    final lower = query.toLowerCase();
    return item.displayName.toLowerCase().contains(lower) || item.phone.toLowerCase().contains(lower);
  }

  /// Виден ли контакт с учётом скрытия. Скрытый профиль показывается, только
  /// если раскрыт текущей «/код-фразой» (см. ContactsCubit.search); иначе он
  /// исчезает из списка. Не скрытые фильтруются по строке поиска как обычно.
  bool _visible(ContactsState state, ContactItem item) {
    final userID = item.userID;
    if (userID != null) {
      final hex = getIt.get<Utils>().bytesToHex(userID);
      if (state.hiddenHashByHex.containsKey(hex)) return state.revealedHex.contains(hex);
    }
    return _matchesQuery(item, state.query);
  }

  Future<void> _invite(String phoneE164) async {
    final uri = Uri.parse('sms:${Uri.encodeComponent(phoneE164)}?body=${Uri.encodeComponent(t.screenContacts.inviteMessage)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Pull-to-refresh: форс-пересинхронизация книги (OPRF), облачных и присутствия.
  Future<void> _refresh() => context.read<ContactsCubit>().refresh();

  @override
  Widget build(BuildContext context) {
    // Белый фон в светлой теме, в ночной — тот же оттенок, что у Cupertino (`groupedCard`),
    // чтобы обе платформы читались одинаково.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return Scaffold(
      // Клавиатура не ужимает список (её закрытие после чата — «пропадающие»
      // нижние чаты): его низ под клавиатурой — отступ в searchListView.
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(context.t.screenContacts.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: context.t.screenContacts.addByNumber,
            onPressed: () => _showAddByNumber(context),
          ),
        ],
      ),
      // Поле поиска — вне BlocBuilder, чтобы не пересоздаваться на каждый emit
      // от search() (иначе теряется фокус/область композиции при вводе).
      body: searchHideOnScrollBody(
        // Шапка (поиск, баннер) поверх списка: поиск уезжает вместе со
        // списком, как в Telegram (см. SearchHideOnScroll).
        background: background,
        search: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: SearchFieldMaterial(
            controller: searchController,
            focusNode: searchFocus,
            hintText: context.t.screenContacts.search,
            onChanged: (value) => context.read<ContactsCubit>().search(value),
          ),
        ),
        header: [
          // Мягкий баннер-объяснение о доступе к книге. Виден, только пока доступ
          // не выдан и пользователь его не закрыл. Поиск и облачные контакты при
          // этом доступны — экран не блокируется.
          BlocSelector<ContactsCubit, ContactsState, bool>(
            selector: (state) => AppPlatform.hasAddressBook && !state.permissionGranted && !state.bannerDismissed,
            builder: (context, showBanner) => showBanner
                ? PermissionBannerMaterial(
                    icon: HugeIcons.strokeRoundedUsersRound,
                    title: context.t.screenContacts.permissionTitle,
                    message: context.t.screenContacts.permissionMessage,
                    actionLabel: context.t.screenContacts.allowAccess,
                    onAction: () => context.read<ContactsCubit>().requestAccess(),
                    onDismiss: () => context.read<ContactsCubit>().dismissBanner(),
                    dismissTooltip: context.t.common.notNow,
                  )
                : const SizedBox.shrink(),
          ),
        ],
        body: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state.status != Status.success && state.registered.isEmpty && state.invitable.isEmpty && state.cloud.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                // Кэш пуст: пока идёт discovery — прогресс поиска (план
                // 01-contacts-loading, шаг 3); голый спиннер — только в короткое
                // окно до его старта.
                child: searchListView(empty: _searchingBook(context, state.discovering, const CircularProgressIndicator())),
              );
            }

            final registered = state.registered.where((item) => _visible(state, item)).toList();
            final invitable = state.invitable.where((item) => _visible(state, item)).toList();
            final cloud = state.cloud.where((item) => _visible(state, item)).toList();

            // Виртуализация (план 01-contacts-loading, шаг 4): список отдаётся
            // itemCount/itemBuilder — плитки строятся лениво по индексу, а не все
            // сразу одним кадром (6000 плиток замораживали растеризатор).
            // Раскладка плоская: секция = заголовок + её плитки, затем результаты
            // глобального поиска людей и пустое состояние.
            final sections = <_ContactsSection>[
              if (registered.isNotEmpty)
                _ContactsSection(header: context.t.screenContacts.onContacts, kind: _SectionKind.registered, items: registered),
              if (cloud.isNotEmpty)
                _ContactsSection(header: context.t.screenContacts.cloudContacts, kind: _SectionKind.cloud, items: cloud),
              if (invitable.isNotEmpty)
                _ContactsSection(header: context.t.screenContacts.invite, kind: _SectionKind.invitable, items: invitable),
            ];
            // Глобальный поиск людей (номер / @username) — тап открывает профиль;
            // результатов немного, остаётся готовым списком.
            final searchRows = usersSearchListMaterial(
              context,
              status: state.query.trim().isEmpty ? UsersSearchStatus.idle : state.globalStatus,
              results: state.globalResults,
              onTap: (member) => openProfileFromList(context, member.id),
            );
            final showEmpty = registered.isEmpty && invitable.isEmpty && cloud.isEmpty && state.globalStatus == UsersSearchStatus.idle;
            final rowCount = sections.fold(0, (n, s) => n + 1 + s.items.length) + searchRows.length + (showEmpty ? 1 : 0);

            // Отступ сверху под шапку — строки проезжают под ней.
            return RefreshIndicator(
              onRefresh: _refresh,
              child: searchListView(
                itemCount: rowCount,
                itemBuilder: (context, index) {
                  var i = index;
                  for (final section in sections) {
                    if (i == 0) return _sectionHeader(context, section.header);
                    i -= 1;
                    if (i < section.items.length) {
                      return _sectionTile(context, section, section.items[i]);
                    }
                    i -= section.items.length;
                  }
                  if (i < searchRows.length) return searchRows[i];
                  return Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(child: Text(context.t.screenContacts.empty)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Заголовок секции («В контактах», «Облачные», «Пригласить»).
  Widget _sectionHeader(BuildContext context, String header) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(header, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }

  /// Плитка секции с учётом её типа (removable — только у облачных).
  Widget _sectionTile(BuildContext context, _ContactsSection section, ContactItem item) {
    return switch (section.kind) {
      _SectionKind.registered => _registeredTile(context, item),
      _SectionKind.cloud =>
        item.isRegistered ? _registeredTile(context, item, removable: true) : _invitableTile(context, item, removable: true),
      _SectionKind.invitable => _invitableTile(context, item),
    };
  }

  /// Пустой экран с прогрессом discovery (план 01-contacts-loading, шаг 3):
  /// подпись «Ищем контакты…» — пока поиск идёт ([discovering]); до его старта —
  /// только [indicator].
  Widget _searchingBook(BuildContext context, bool discovering, Widget indicator) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (discovering) ...[
          Text(context.t.screenContacts.searchingBook, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
        ],
        indicator,
      ],
    );
  }

  /// Статус контакта: «в сети» (зелёная точка), «был(а) <дата>» или «был(а) недавно».
  /// TODO: подключить реальные данные о присутствии — сейчас плейсхолдер.
  Widget _status(BuildContext context, {bool online = false, DateTime? lastSeen}) {
    if (online) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(context.t.screenContacts.statusOnline, style: const TextStyle(color: Colors.green)),
        ],
      );
    }
    final text = lastSeen != null
        ? context.t.screenContacts.statusLastSeen(date: lastSeen.relativeFormat(context.t))
        : context.t.screenContacts.statusLastSeenRecently;
    return Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant));
  }

  /// Свайп-удаление ([removable]) есть только у «облачных» контактов — их
  /// пользователь добавил вручную и ими управляет в приложении. Контакты из
  /// телефонной книги не удаляются здесь (их место — системная адресная книга).
  Widget _registeredTile(BuildContext context, ContactItem item, {bool removable = false}) {
    final hex = getIt.get<Utils>().bytesToHex(item.userID!);
    final tile = ListTile(
      leading: UserAvatar(userID: item.userID, placeholderName: hex),
      title: Text(item.displayName),
      subtitle: _status(context, online: item.online, lastSeen: item.lastSeen),
      trailing: const Icon(Icons.chevron_right),
      selected: SplitSelection.of(context) == hex,
      selectedTileColor: Theme.of(context).colorScheme.secondaryContainer,
      onTap: () => openProfileFromList(context, hex),
    );
    return removable ? _dismissible(context, item, tile) : tile;
  }

  /// Обёртка свайпа «удалить» (только для облачных контактов).
  Widget _dismissible(BuildContext context, ContactItem item, Widget child) {
    final cubit = context.read<ContactsCubit>();
    return Dismissible(
      key: ValueKey('contact_${item.phoneE164}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemove(context),
      onDismissed: (_) => cubit.removeContact(item),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(context.t.screenContacts.remove, style: const TextStyle(color: Colors.white)),
      ),
      child: child,
    );
  }

  /// Диалог подтверждения удаления контакта из облачной книги.
  Future<bool> _confirmRemove(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.screenContacts.removeTitle),
        content: Text(context.t.screenContacts.removeMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(context.t.screenContacts.remove)),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Открывает полноэкранную форму добавления по номеру; по возврату (pop с
  /// [ContactAddInput]) зовёт cubit.addByNumber и показывает результат снэкбаром.
  Future<void> _showAddByNumber(BuildContext context) async {
    final cubit = context.read<ContactsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final t = context.t.screenContacts;

    final input = await context.push<ContactAddInput>('/contacts/add');
    if (input == null) return;

    final result = await cubit.addByNumber(firstName: input.firstName, lastName: input.lastName, rawNumber: input.phone);
    // Нет сети — общий алерт «нет интернета» (нижняя плашка), единый для звонков
    // и контактов; ему нужен живой контекст, поэтому проверяем mounted.
    if (result == ContactAddResult.noConnection) {
      if (context.mounted) showNoConnectionAlert(context);
      return;
    }
    // Успех не показываем: добавленный контакт сразу появляется в списке
    // (оптимистично) — снэкбар лишний. Сообщаем только об ошибках.
    final message = switch (result) {
      ContactAddResult.addedRegistered || ContactAddResult.addedPending => null,
      ContactAddResult.invalidNumber => t.addInvalidNumber,
      ContactAddResult.limitReached => t.validationCloudLimitReached,
      ContactAddResult.noConnection => null,
      ContactAddResult.failed => t.addFailed,
    };
    if (message == null) return;
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _invitableTile(BuildContext context, ContactItem item, {bool removable = false}) {
    final tile = ListTile(
      leading: UserAvatar(userID: item.userID, placeholderName: item.phoneE164),
      title: Text(item.displayName),
      subtitle: Text(item.phone),
      trailing: TextButton(onPressed: () => _invite(item.phoneE164), child: Text(context.t.screenContacts.inviteAction)),
    );
    return removable ? _dismissible(context, item, tile) : tile;
  }
}

/// Тип секции списка контактов — определяет вид плиток ([_sectionTile]).
enum _SectionKind { registered, cloud, invitable }

/// Секция виртуализированного списка: заголовок + её плитки. Виджеты строятся
/// лениво в itemBuilder по плоскому индексу (план 01-contacts-loading, шаг 4).
class _ContactsSection {
  final String header;
  final _SectionKind kind;
  final List<ContactItem> items;

  const _ContactsSection({required this.header, required this.kind, required this.items});
}
