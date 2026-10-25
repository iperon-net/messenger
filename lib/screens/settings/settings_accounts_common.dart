import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../accounts.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';

/// Список аккаунтов в «Настройках» (этап 3.2 мультиаккаунта): общее для
/// Material и Cupertino — данные, подписка на изменения, действия.
mixin SettingsAccountsState<T extends StatefulWidget> on State<T> {
  List<AccountEntry> accounts = const [];
  StreamSubscription<void>? _changes;
  AppLifecycleListener? _lifecycle;
  Timer? _refresh;

  /// Как часто перечитывать непрочитанные неактивных: их пуши приходят нативу,
  /// Dart о них не знает.
  static const _refreshInterval = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    unawaited(load());
    _changes = accountsChanged().listen((_) => unawaited(load()));
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(load()));
    _refresh = Timer.periodic(_refreshInterval, (_) {
      if (accounts.length > 1) unawaited(load());
    });
  }

  /// Перечитать список (с непрочитанными неактивных).
  Future<void> load() async {
    final list = await signedInAccounts(withUnread: true);
    if (mounted && !listEquals(list, accounts)) setState(() => accounts = list);
  }

  @override
  void dispose() {
    _changes?.cancel();
    _lifecycle?.dispose();
    _refresh?.cancel();
    super.dispose();
  }

  /// Аватар аккаунта: файл, если скачан.
  ImageProvider? avatarOf(AccountEntry account) => account.avatarPath.isEmpty ? null : FileImage(File(account.avatarPath));

  /// Первая буква подписи — вместо аватара.
  String initialOf(AccountEntry account) {
    final title = account.title.replaceAll('+', '').trim();
    return title.isEmpty ? '?' : title.characters.first.toUpperCase();
  }

  /// Во время звонка аккаунт не переключить.
  bool get callActive {
    final status = getIt.get<Calls>().snapshot.status;
    return status != CallStatus.idle && status != CallStatus.ended;
  }

  /// Сообщение пользователю: Cupertino — диалог, Material — SnackBar.
  Future<void> notice(String text);

  /// Тап по аккаунту: переключиться (кроме активного; не во время звонка).
  Future<void> pickAccount(AccountEntry account) async {
    if (account.active) return;
    if (callActive) return notice(context.t.screenSettings.accountSwitchCallActive);
    await switchAccount(account.accountID);
  }

  /// «Добавить аккаунт» (не во время звонка, не больше [maxAccounts]).
  Future<void> startAddAccount() async {
    if (callActive) return notice(context.t.screenSettings.accountSwitchCallActive);
    if (!await canAddAccount()) {
      if (mounted) await notice(context.t.screenSettings.accountsLimit(count: maxAccounts));
      return;
    }
    await addAccount();
  }
}
