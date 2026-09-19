import 'dart:typed_data';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../repositories/repositories.dart';
import '../../themes.dart';
import '../../utils.dart';

/// Пикер списка-исключений для звонков — allow «Всегда разрешать» (под «Никто»)
/// или deny «Всегда запрещать» (под «Мои контакты»), выбирается [kind]. Показывает
/// контакты (книжные + облачные), зарегистрированные в Iperon (у которых есть
/// userID); незарегистрированные скрыты — гейт работает только по userID.
/// Множественный выбор, сохранение заменяет список целиком через
/// [SettingsPrivacyAndSecurityCubit].
class SettingsPrivacyCallsAllowCupertino extends StatefulWidget {
  final CallsListKind kind;
  final List<Uint8List> initialSelected;

  const SettingsPrivacyCallsAllowCupertino({required this.kind, required this.initialSelected, super.key});

  @override
  State<SettingsPrivacyCallsAllowCupertino> createState() => _SettingsPrivacyCallsAllowCupertino();
}

class _SettingsPrivacyCallsAllowCupertino extends State<SettingsPrivacyCallsAllowCupertino> {
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  // Кандидаты: dedup по userID. hex(userID) -> отображаемое имя/телефон.
  List<_AllowCandidate> _candidates = const [];
  bool _loading = true;

  // Выбранные — по hex(userID).
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
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final ok = widget.kind == CallsListKind.allow ? await cubit.setCallsAllow(selectedIDs) : await cubit.setCallsDeny(selectedIDs);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = false);
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.common.noConnectionTitle),
        content: Text(context.t.common.noConnectionMessage),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.t.common.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(
            widget.kind == CallsListKind.allow
                ? context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow
                : context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
          ),
          trailing: _saving
              ? const CupertinoActivityIndicator()
              : CupertinoButton(padding: EdgeInsets.zero, onPressed: _save, child: Text(context.t.common.done)),
        ),
      ),
      child: SafeArea(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : _candidates.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.callsAllowEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: CupertinoSearchTextField(
                      placeholder: context.t.screenContacts.search,
                      onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                    ),
                  ),
                  Expanded(
                    child: _filtered.isEmpty
                        ? Center(
                            child: Text(
                              context.t.screenContacts.empty,
                              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                            ),
                          )
                        : ListView(
                            children: [
                              CupertinoListSection.insetGrouped(
                                backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                                decoration: BoxDecoration(
                                  color: ThemesCupertino.groupedCard.resolveFrom(context),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                children: [
                                  for (final c in _filtered)
                                    CupertinoListTile(
                                      title: Text(c.name),
                                      subtitle: c.phone.isEmpty ? null : Text(c.phone),
                                      additionalInfo: _selected.contains(c.hex)
                                          ? FaIcon(
                                              FontAwesomeIcons.solidCircleCheck,
                                              size: 18,
                                              color: CupertinoTheme.of(context).primaryColor,
                                            )
                                          : null,
                                      onTap: () =>
                                          setState(() => _selected.contains(c.hex) ? _selected.remove(c.hex) : _selected.add(c.hex)),
                                    ),
                                ],
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
