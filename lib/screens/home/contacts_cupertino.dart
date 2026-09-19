import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../themes.dart';
import '../../components.dart';
import '../../utils.dart';
import '../../i18n/translations.g.dart';

/// Экран «Контакты»: сверху — найденные в Iperon (тап → профиль), ниже —
/// остальные с кнопкой «Пригласить». Приватный поиск через OPRF (см. ContactsCubit).
class ContactsCupertino extends StatefulWidget {
  const ContactsCupertino({super.key});

  @override
  State<ContactsCupertino> createState() => _ContactsCupertinoState();
}

class _ContactsCupertinoState extends State<ContactsCupertino> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Первый показ вкладки — осознанный момент запросить доступ и запустить поиск
    // (если фоновая дозагрузка на shell ещё не стартовала при уже выданном доступе).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ContactsCubit>().discoverOnFirstView();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(ContactItem item, String query) {
    if (query.isEmpty) return true;
    final lower = query.toLowerCase();
    return item.displayName.toLowerCase().contains(lower) || item.phone.toLowerCase().contains(lower);
  }

  Future<void> _invite(String phoneE164) async {
    final uri = Uri.parse('sms:${Uri.encodeComponent(phoneE164)}?body=${Uri.encodeComponent(t.screenContacts.inviteMessage)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.appBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.appBackground,
          middle: Text(context.t.screenContacts.title),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showAddByNumber(context),
            child: const Icon(CupertinoIcons.add),
          ),
        ),
      ),
      child: SafeArea(
        // Поле поиска — вне BlocBuilder, чтобы не пересоздаваться на каждый emit
        // от search(). На iOS перестроение CupertinoTextField во время ввода
        // сбрасывает область композиции клавиатуры, из-за чего onChanged
        // «залипал» и результат появлялся только после нажатия Enter.
        // BlocSelector перестраивает поле только при смене permissionDenied.
        child: Column(
          children: [
            BlocSelector<ContactsCubit, ContactsState, bool>(
              selector: (state) => state.permissionDenied,
              builder: (context, permissionDenied) {
                if (permissionDenied) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: context.t.screenContacts.search,
                    onChanged: (value) => context.read<ContactsCubit>().search(value),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ContactsCubit, ContactsState>(
                builder: (context, state) {
                  if (state.permissionDenied) return _permission(context);

                  if (state.status != Status.success && state.registered.isEmpty && state.invitable.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final registered = state.registered.where((item) => _matchesQuery(item, state.query)).toList();
                  final invitable = state.invitable.where((item) => _matchesQuery(item, state.query)).toList();
                  final cloud = state.cloud.where((item) => _matchesQuery(item, state.query)).toList();

                  return ListView(
                    children: [
                      if (registered.isNotEmpty)
                        _sheet(
                          context,
                          context.t.screenContacts.onContacts,
                          registered.map((item) => _registeredTile(context, item)).toList(),
                        ),
                      if (cloud.isNotEmpty)
                        _sheet(
                          context,
                          context.t.screenContacts.cloudContacts,
                          cloud
                              .map(
                                (item) => item.isRegistered
                                    ? _registeredTile(context, item, removable: true)
                                    : _invitableTile(context, item, removable: true),
                              )
                              .toList(),
                        ),
                      if (invitable.isNotEmpty)
                        _sheet(context, context.t.screenContacts.invite, invitable.map((item) => _invitableTile(context, item)).toList()),
                      if (registered.isEmpty && invitable.isEmpty && cloud.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Center(child: Text(context.t.screenContacts.empty)),
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

  /// Белая подложка без обрамления (без инсет-полей и скруглений) — контакты
  /// лежат на сплошном листе во всю ширину, разделённые тонкими линиями.
  Widget _sheet(BuildContext context, String header, List<Widget> tiles) {
    final divider = Container(
      margin: const EdgeInsetsDirectional.only(start: 60),
      height: 0.5,
      color: CupertinoColors.separator.resolveFrom(context),
    );

    final children = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      if (i > 0) children.add(divider);
      children.add(tiles[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 6),
          child: Text(
            header.toUpperCase(),
            style: TextStyle(fontSize: 13, letterSpacing: -0.08, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
        ),
        Container(
          color: ThemesCupertino.appBackground.resolveFrom(context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
        ),
      ],
    );
  }

  /// Статус контакта: «в сети» (зелёная точка), «был(а) <дата>» или «был(а) недавно».
  /// TODO: подключить реальные данные о присутствии — сейчас плейсхолдер.
  Widget _status(BuildContext context, {bool online = false, DateTime? lastSeen}) {
    if (online) {
      final green = ThemesCupertino().green.resolveFrom(context);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(context.t.screenContacts.statusOnline, style: TextStyle(fontSize: 14, color: green)),
        ],
      );
    }
    final text = lastSeen != null
        ? context.t.screenContacts.statusLastSeen(date: lastSeen.relativeFormat(context.t))
        : context.t.screenContacts.statusLastSeenRecently;
    return Text(text, style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel.resolveFrom(context)));
  }

  /// Свайп-удаление ([removable]) есть только у «облачных» контактов — их
  /// пользователь добавил вручную и ими управляет в приложении. Контакты из
  /// телефонной книги не удаляются здесь (их место — системная адресная книга).
  Widget _registeredTile(BuildContext context, ContactItem item, {bool removable = false}) {
    final hex = getIt.get<Utils>().bytesToHex(item.userID!);
    final tile = CupertinoListTile(
      leading: UserAvatar(userID: item.userID, placeholderName: hex),
      title: Text(item.displayName),
      subtitle: _status(context, online: item.online, lastSeen: item.lastSeen),
      trailing: const CupertinoListTileChevron(),
      onTap: () => context.push('/profile/$hex'),
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
        color: CupertinoColors.destructiveRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(context.t.screenContacts.remove, style: const TextStyle(color: CupertinoColors.white)),
      ),
      child: child,
    );
  }

  /// Диалог подтверждения удаления контакта из облачной книги.
  Future<bool> _confirmRemove(BuildContext context) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.screenContacts.removeTitle),
        content: Text(context.t.screenContacts.removeMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.t.screenContacts.remove),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Открывает полноэкранную форму добавления по номеру; по возврату (pop с
  /// [ContactAddInput]) зовёт cubit.addByNumber и показывает результат.
  Future<void> _showAddByNumber(BuildContext context) async {
    final cubit = context.read<ContactsCubit>();
    final input = await context.push<ContactAddInput>('/contacts/add');
    if (input == null || !context.mounted) return;

    final result = await cubit.addByNumber(firstName: input.firstName, lastName: input.lastName, rawNumber: input.phone);
    if (!context.mounted) return;
    _showAddResult(context, result);
  }

  void _showAddResult(BuildContext context, ContactAddResult result) {
    final t = context.t.screenContacts;
    // Нет сети — общий алерт «нет интернета» (единый для звонков и контактов).
    if (result == ContactAddResult.noConnection) {
      showNoConnectionAlert(context);
      return;
    }
    // Успех не показываем: добавленный контакт сразу появляется в списке
    // (оптимистично) — баннер лишний. Сообщаем только об ошибках.
    final message = switch (result) {
      ContactAddResult.addedRegistered || ContactAddResult.addedPending => null,
      ContactAddResult.invalidNumber => t.addInvalidNumber,
      ContactAddResult.limitReached => t.validationCloudLimitReached,
      ContactAddResult.noConnection => null,
      ContactAddResult.failed => t.addFailed,
    };
    if (message == null) return;

    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        content: Text(message),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.done))],
      ),
    );
  }

  Widget _invitableTile(BuildContext context, ContactItem item, {bool removable = false}) {
    final tile = CupertinoListTile(
      leading: UserAvatar(userID: item.userID, placeholderName: item.phoneE164),
      title: Text(item.displayName),
      subtitle: Text(item.phone),
      trailing: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onPressed: () => _invite(item.phoneE164),
        child: Text(context.t.screenContacts.inviteAction),
      ),
    );
    return removable ? _dismissible(context, item, tile) : tile;
  }

  Widget _permission(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.person_2, size: 56),
            const SizedBox(height: 16),
            Text(
              context.t.screenContacts.permissionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(context.t.screenContacts.permissionMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () => context.read<ContactsCubit>().requestAccess(),
              child: Text(context.t.screenContacts.allowAccess),
            ),
          ],
        ),
      ),
    );
  }
}
