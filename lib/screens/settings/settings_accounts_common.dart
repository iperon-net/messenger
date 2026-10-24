import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../accounts.dart';
import '../../calls.dart';
import '../../di.dart';

/// Список аккаунтов в «Настройках» (этап 3.2 мультиаккаунта): общее для
/// Material и Cupertino — данные, подписка на изменения, действия.
mixin SettingsAccountsState<T extends StatefulWidget> on State<T> {
  List<AccountEntry> accounts = const [];
  StreamSubscription<void>? _changes;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    _changes = accountsChanged().listen((_) => unawaited(_load()));
  }

  Future<void> _load() async {
    final list = await signedInAccounts();
    if (mounted) setState(() => accounts = list);
  }

  @override
  void dispose() {
    _changes?.cancel();
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
}
