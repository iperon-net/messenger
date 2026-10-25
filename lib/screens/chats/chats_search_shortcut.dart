import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_shortcuts.dart';
import '../../components/search_hide_on_scroll.dart';
import '../../cubit.dart';

/// Вкладка «Чаты» по быстрому действию иконки «Поиск»
/// ([AppShortcuts.searchRequested]): поднимает строку поиска и ставит фокус —
/// не под экраном код-пароля (клавиатура вылезла бы поверх него), а после
/// разблокировки. Общее для Cupertino и Material.
mixin ChatsSearchShortcut<T extends StatefulWidget> on SearchHideOnScroll<T> {
  StreamSubscription<CommonState>? _lockChanges;
  AppLifecycleListener? _lifecycle;

  /// Пауза после возврата в приложение: фокус, поставленный до того, как окно
  /// получило фокус ввода, клавиатуру не поднимает.
  static const _focusDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    AppShortcuts.searchRequested.addListener(_onSearchRequested);
    _lockChanges = context.read<CommonCubit>().stream.listen((_) => _onSearchRequested());
    _lifecycle = AppLifecycleListener(onResume: _onSearchRequested);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onSearchRequested());
  }

  @override
  void dispose() {
    AppShortcuts.searchRequested.removeListener(_onSearchRequested);
    _lockChanges?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }

  void _onSearchRequested() {
    if (!mounted || !AppShortcuts.searchRequested.value) return;
    if (context.read<CommonCubit>().state.isLocked) return;
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) return;
    AppShortcuts.searchRequested.value = false;
    Future<void>.delayed(_focusDelay, () {
      if (mounted) revealSearch();
    });
  }
}
