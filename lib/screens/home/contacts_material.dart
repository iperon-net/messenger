import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../utils.dart';
import '../../i18n/translations.g.dart';

/// Экран «Контакты» (Android): найденные в Iperon + приглашения. Приватный поиск
/// через OPRF (см. ContactsCubit).
class ContactsMaterial extends StatelessWidget {
  const ContactsMaterial({super.key});

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
    return Scaffold(
      appBar: AppBar(title: Text(context.t.screenContacts.title)),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state.permissionDenied) return _permission(context);

          if (state.status != Status.success && state.registered.isEmpty && state.invitable.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final registered = state.registered.where((item) => _matchesQuery(item, state.query)).toList();
          final invitable = state.invitable.where((item) => _matchesQuery(item, state.query)).toList();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.t.screenContacts.search,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) => context.read<ContactsCubit>().search(value),
                ),
              ),
              if (registered.isNotEmpty) _header(context, context.t.screenContacts.onIperon),
              ...registered.map((item) => _registeredTile(context, item)),
              if (invitable.isNotEmpty) _header(context, context.t.screenContacts.invite),
              ...invitable.map((item) => _invitableTile(context, item)),
              if (registered.isEmpty && invitable.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(child: Text(context.t.screenContacts.empty)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
  );

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

  Widget _registeredTile(BuildContext context, ContactItem item) {
    final hex = getIt.get<Utils>().bytesToHex(item.userID!);
    return ListTile(
      leading: _avatar(hex),
      title: Text(item.displayName),
      subtitle: Text(item.phone),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/profile/$hex'),
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
            FilledButton(onPressed: () => context.read<ContactsCubit>().refresh(), child: Text(context.t.screenContacts.allowAccess)),
            TextButton(onPressed: openAppSettings, child: Text(context.t.screenContacts.openSettings)),
          ],
        ),
      ),
    );
  }
}
