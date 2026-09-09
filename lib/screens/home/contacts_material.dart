import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(backgroundColor: background, title: Text(context.t.screenContacts.title)),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state.permissionDenied) return _permission(context);

          if (state.status != Status.success && state.registered.isEmpty && state.invitable.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final registered = state.registered.where((item) => _matchesQuery(item, state.query)).toList();
          final invitable = state.invitable.where((item) => _matchesQuery(item, state.query)).toList();

          // Поле поиска — вне списка, чтобы не пересоздаваться при каждом emit
          // (иначе оно теряет фокус и onChanged перестаёт срабатывать по клавише).
          return Column(
            children: [
              Padding(
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
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (registered.isNotEmpty)
                      _sheet(
                        context,
                        context.t.screenContacts.onContacts,
                        registered.map((item) => _registeredTile(context, item)).toList(),
                      ),
                    if (invitable.isNotEmpty)
                      _sheet(context, context.t.screenContacts.invite, invitable.map((item) => _invitableTile(context, item)).toList()),
                    if (registered.isEmpty && invitable.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(child: Text(context.t.screenContacts.empty)),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
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
    return ListTile(
      leading: _avatar(hex),
      title: Text(item.displayName),
      // TODO: заменить плейсхолдер на реальную дату последнего визита из данных о присутствии.
      subtitle: _status(context, lastSeen: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/profile/$hex'),
    );
  }

  Widget _invitableTile(BuildContext context, ContactItem item) {
    return ListTile(
      leading: _avatar(item.phoneE164),
      title: Text(item.displayName),
      subtitle: Text(item.phone),
      trailing: TextButton(onPressed: () => _invite(item.phoneE164), child: Text(context.t.screenContacts.inviteAction)),
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
