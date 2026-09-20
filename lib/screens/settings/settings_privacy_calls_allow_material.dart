import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';

/// Пикер списка-исключений для звонков — allow «Всегда разрешать» (под «Никто»)
/// или deny «Всегда запрещать» (под «Мои контакты»), выбирается [kind]. Показывает
/// контакты (книжные + облачные), зарегистрированные в Iperon (у которых есть
/// userID); незарегистрированные скрыты — гейт работает только по userID.
/// Множественный выбор, сохранение заменяет список целиком через
/// [SettingsPrivacyAndSecurityCubit].
class SettingsPrivacyCallsAllowMaterial extends StatefulWidget {
  final CallsListKind kind;
  final List<Uint8List> initialSelected;

  /// Канал, чей список исключений редактируем: звонки или день рождения. Пикер
  /// один на оба — от [channel]+[kind] зависит только, какой сеттер cubit вызвать.
  final PrivacyChannel channel;

  const SettingsPrivacyCallsAllowMaterial({
    required this.kind,
    required this.initialSelected,
    this.channel = PrivacyChannel.calls,
    super.key,
  });

  @override
  State<SettingsPrivacyCallsAllowMaterial> createState() => _SettingsPrivacyCallsAllowMaterial();
}

class _SettingsPrivacyCallsAllowMaterial extends State<SettingsPrivacyCallsAllowMaterial> {
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  List<_AllowCandidate> _candidates = const [];
  bool _loading = true;

  late Set<String> _selected;
  bool _saving = false;

  // Строка поиска (нижний регистр); фильтрует кандидатов по имени/телефону.
  String _query = "";

  List<_AllowCandidate> get _filtered {
    if (_query.isEmpty) return _candidates;
    return _candidates.where((c) => c.name.toLowerCase().contains(_query) || c.phone.toLowerCase().contains(_query)).toList();
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected.map(utils.bytesToHex).toSet();
    _load();
  }

  Future<void> _load() async {
    final entries = await repositories.contacts.getAll();
    final byHex = <String, _AllowCandidate>{};
    for (final e in entries) {
      final id = e.userID;
      if (id == null || id.isEmpty) continue; // только зарегистрированные
      final hex = utils.bytesToHex(Uint8List.fromList(id));
      byHex.putIfAbsent(hex, () => _AllowCandidate(userID: Uint8List.fromList(id), hex: hex, name: e.displayName, phone: e.phone));
    }
    final list = byHex.values.toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (!mounted) return;
    setState(() {
      _candidates = list;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final selectedIDs = _candidates.where((c) => _selected.contains(c.hex)).map((c) => c.userID).toList(growable: false);
    final messenger = ScaffoldMessenger.of(context);
    final message = context.t.common.noConnectionMessage;
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = widget.kind == CallsListKind.allow;
    final bool ok;
    switch (widget.channel) {
      case PrivacyChannel.calls:
        ok = isAllow ? await cubit.setCallsAllow(selectedIDs) : await cubit.setCallsDeny(selectedIDs);
      case PrivacyChannel.birthday:
        ok = isAllow ? await cubit.setBirthdayAllow(selectedIDs) : await cubit.setBirthdayDeny(selectedIDs);
      case PrivacyChannel.aboutMe:
        ok = isAllow ? await cubit.setAboutMeAllow(selectedIDs) : await cubit.setAboutMeDeny(selectedIDs);
    }
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          widget.kind == CallsListKind.allow
              ? context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow
              : context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
        ),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : TextButton(onPressed: _save, child: Text(context.t.common.done)),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _candidates.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.callsAllowEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            : Column(
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
                      onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                    ),
                  ),
                  Expanded(
                    child: _filtered.isEmpty
                        ? Center(
                            child: Text(
                              context.t.screenContacts.empty,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          )
                        : ListView(
                            children: [
                              for (final c in _filtered)
                                ListTile(
                                  title: Text(c.name),
                                  subtitle: c.phone.isEmpty ? null : Text(c.phone),
                                  trailing: _selected.contains(c.hex)
                                      ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                                      : null,
                                  onTap: () => setState(() => _selected.contains(c.hex) ? _selected.remove(c.hex) : _selected.add(c.hex)),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AllowCandidate {
  final Uint8List userID;
  final String hex;
  final String name;
  final String phone;

  const _AllowCandidate({required this.userID, required this.hex, required this.name, required this.phone});
}
