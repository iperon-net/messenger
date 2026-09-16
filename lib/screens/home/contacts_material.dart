import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../themes.dart';
import '../../utils.dart';
import '../../i18n/translations.g.dart';

/// Экран «Контакты» (Android): найденные в Iperon + приглашения. Приватный поиск
/// через OPRF (см. ContactsCubit).
class ContactsMaterial extends StatefulWidget {
  const ContactsMaterial({super.key});

  @override
  State<ContactsMaterial> createState() => _ContactsMaterialState();
}

class _ContactsMaterialState extends State<ContactsMaterial> {
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
    // Белый фон в светлой теме, в ночной — тот же оттенок, что у Cupertino (`groupedCard`),
    // чтобы обе платформы читались одинаково.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return Scaffold(
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
      // BlocSelector перестраивает поле только при смене permissionDenied.
      body: Column(
        children: [
          BlocSelector<ContactsCubit, ContactsState, bool>(
            selector: (state) => state.permissionDenied,
            builder: (context, permissionDenied) {
              if (permissionDenied) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.t.screenContacts.search,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
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
                  return const Center(child: CircularProgressIndicator());
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
                        cloud.map((item) => item.isRegistered ? _registeredTile(context, item) : _invitableTile(context, item)).toList(),
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
    );
  }

  /// Белая подложка под контактами: сплошной лист во всю ширину с заголовком секции.
  Widget _sheet(BuildContext context, String header, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(header, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
        ),
        Material(
          type: MaterialType.transparency,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: tiles),
        ),
      ],
    );
  }

  Widget _avatar(String hash) => SizedBox(
    width: 40,
    height: 40,
    child: AnimatedBoringAvatar(
      name: hash,
      type: BoringAvatarType.beam,
      shape: const CircleBorder(),
      duration: const Duration(milliseconds: 400),
    ),
  );

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

  Widget _registeredTile(BuildContext context, ContactItem item) {
    final hex = getIt.get<Utils>().bytesToHex(item.userID!);
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
      child: ListTile(
        leading: _avatar(hex),
        title: Text(item.displayName),
        // TODO: заменить плейсхолдер на реальную дату последнего визита из данных о присутствии.
        subtitle: _status(context, lastSeen: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/profile/$hex'),
      ),
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

  /// Диалог ручного добавления контакта по номеру (имя, фамилия, телефон с
  /// форматированием). По подтверждению зовёт cubit.addByNumber и показывает
  /// результат снэкбаром.
  Future<void> _showAddByNumber(BuildContext context) async {
    final cubit = context.read<ContactsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final t = context.t.screenContacts;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.addByNumber),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: t.addFirstName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: t.addLastName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneInputFormatter()],
              decoration: InputDecoration(labelText: t.addByNumberHint, prefixIcon: const Icon(Icons.phone)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.add)),
        ],
      ),
    );

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();

    if (confirmed != true || phone.isEmpty) return;

    final result = await cubit.addByNumber(firstName: firstName, lastName: lastName, rawNumber: phone);
    final message = switch (result) {
      ContactAddResult.addedRegistered => t.addedRegistered,
      ContactAddResult.addedPending => t.addedPending,
      ContactAddResult.invalidNumber => t.addInvalidNumber,
      ContactAddResult.failed => t.addFailed,
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _invitableTile(BuildContext context, ContactItem item) {
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
      child: ListTile(
        leading: _avatar(item.phoneE164),
        title: Text(item.displayName),
        subtitle: Text(item.phone),
        trailing: TextButton(onPressed: () => _invite(item.phoneE164), child: Text(context.t.screenContacts.inviteAction)),
      ),
    );
  }

  Widget _permission(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.contacts_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              context.t.screenContacts.permissionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(context.t.screenContacts.permissionMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => context.read<ContactsCubit>().requestAccess(), child: Text(context.t.screenContacts.allowAccess)),
          ],
        ),
      ),
    );
  }
}
