import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
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
class ContactsCupertino extends StatelessWidget {
  const ContactsCupertino({super.key});

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
      backgroundColor: ThemesCupertino.groupedCard,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedCard,
          middle: Text(context.t.screenContacts.title),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state.permissionDenied) return _permission(context);

            if (state.status != Status.success && state.registered.isEmpty && state.invitable.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final registered = state.registered.where((item) => _matchesQuery(item, state.query)).toList();
            final invitable = state.invitable.where((item) => _matchesQuery(item, state.query)).toList();

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CupertinoSearchTextField(
                    placeholder: context.t.screenContacts.search,
                    onChanged: (value) => context.read<ContactsCubit>().search(value),
                  ),
                ),
                if (registered.isNotEmpty)
                  _sheet(context, context.t.screenContacts.onIperon, registered.map((item) => _registeredTile(context, item)).toList()),
                if (invitable.isNotEmpty)
                  _sheet(context, context.t.screenContacts.invite, invitable.map((item) => _invitableTile(context, item)).toList()),
                if (registered.isEmpty && invitable.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(child: Text(context.t.screenContacts.empty)),
                  ),
              ],
            );
          },
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
        Container(
          color: ThemesCupertino.groupedCard.resolveFrom(context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
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

  Widget _registeredTile(BuildContext context, ContactItem item) {
    final hex = getIt.get<Utils>().bytesToHex(item.userID!);
    return CupertinoListTile(
      leading: _avatar(hex),
      title: Text(item.displayName),
      // TODO: заменить плейсхолдер на реальную дату последнего визита из данных о присутствии.
      subtitle: _status(context, lastSeen: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
      trailing: const CupertinoListTileChevron(),
      onTap: () => context.push('/profile/$hex'),
    );
  }

  Widget _invitableTile(BuildContext context, ContactItem item) {
    return CupertinoListTile(
      leading: _avatar(item.phoneE164),
      title: Text(item.displayName),
      subtitle: Text(item.phone),
      trailing: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onPressed: () => _invite(item.phoneE164),
        child: Text(context.t.screenContacts.inviteAction),
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
              onPressed: () => context.read<ContactsCubit>().refresh(),
              child: Text(context.t.screenContacts.allowAccess),
            ),
            CupertinoButton(onPressed: openAppSettings, child: Text(context.t.screenContacts.openSettings)),
          ],
        ),
      ),
    );
  }
}
