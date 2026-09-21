import 'dart:typed_data';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../calls.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../extensions.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import '../../utils.dart';
import '../../i18n/translations.g.dart';

/// Вкладка «Звонки» (iOS): журнал недавних с аватаром, направлением (иконка),
/// длительностью и датой; пропущенные выделены красным. Сверху — поиск и быстрый
/// фильтр «Все/Пропущенные», свайп по строке удаляет запись, кнопка в навбаре
/// очищает всю историю. Доступ к микрофону запрашиваем при первом показе (нужен
/// для звонков), но саму историю им не блокируем.
class CallsCupertino extends StatefulWidget {
  const CallsCupertino({super.key});

  @override
  State<CallsCupertino> createState() => _CallsCupertinoState();
}

class _CallsCupertinoState extends State<CallsCupertino> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Первый показ вкладки — осознанный момент запросить доступ к микрофону,
    // чтобы к моменту звонка он уже был выдан. Историю не блокируем.
    WidgetsBinding.instance.addPostFrameCallback((_) => Permission.microphone.request());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.appBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.appBackground,
          middle: Text(context.t.screenCalls.title),
          trailing: BlocSelector<CallsCubit, CallsState, bool>(
            selector: (state) => state.calls.isNotEmpty,
            builder: (context, hasCalls) {
              if (!hasCalls) return const SizedBox.shrink();
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _confirmClear(context),
                child: Text(context.t.screenCalls.clear),
              );
            },
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Поле поиска — вне BlocBuilder, чтобы не пересоздаваться на каждый
            // emit (иначе на iOS сбрасывается область композиции клавиатуры).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: context.t.screenCalls.search,
                onChanged: (value) => context.read<CallsCubit>().search(value),
              ),
            ),
            Expanded(
              child: BlocBuilder<CallsCubit, CallsState>(
                builder: (context, state) {
                  final items = _visible(context, state);
                  return Column(
                    children: [
                      if (state.calls.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: CupertinoSlidingSegmentedControl<CallsFilter>(
                            groupValue: state.filter,
                            onValueChanged: (value) {
                              if (value != null) context.read<CallsCubit>().setFilter(value);
                            },
                            children: {
                              CallsFilter.all: Text(context.t.screenCalls.filterAll),
                              CallsFilter.missed: Text(context.t.screenCalls.filterMissed),
                            },
                          ),
                        ),
                      Expanded(child: _list(context, state, items)),
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

  Widget _list(BuildContext context, CallsState state, List<models.CallLog> items) {
    if (items.isEmpty) {
      final text = state.filter == CallsFilter.missed && state.query.isEmpty
          ? context.t.screenCalls.emptyMissed
          : context.t.screenCalls.empty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
        ),
      );
    }

    final divider = Container(
      margin: const EdgeInsetsDirectional.only(start: 72),
      height: 0.5,
      color: CupertinoColors.separator.resolveFrom(context),
    );

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => divider,
      itemBuilder: (context, index) => _tile(context, state, items[index]),
    );
  }

  Widget _tile(BuildContext context, CallsState state, models.CallLog log) {
    final utils = getIt.get<Utils>();
    final hex = utils.bytesToHex(log.userID);
    final name = _displayName(context, state, log);
    final red = CupertinoColors.systemRed.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);

    final tile = CupertinoListTile(
      leading: UserAvatar(userID: Uint8List.fromList(log.userID), placeholderName: hex),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: log.missed ? red : CupertinoColors.label.resolveFrom(context)),
      ),
      subtitle: Row(
        children: [
          Icon(_directionIcon(log), size: 15, color: log.missed ? red : secondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              _typeLine(context, log),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: secondary),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(log.createdAt.relativeFormat(context.t), style: TextStyle(fontSize: 13, color: secondary)),
          const SizedBox(width: 4),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => getIt.get<Calls>().startCall(toUserID: log.userID, video: log.video),
            child: Icon(
              log.video ? CupertinoIcons.videocam_fill : CupertinoIcons.phone_fill,
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      onTap: () => context.push('/profile/$hex'),
    );

    return Dismissible(
      key: ValueKey('call_${log.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<CallsCubit>().delete(log),
      background: Container(
        color: CupertinoColors.destructiveRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(context.t.screenCalls.delete, style: const TextStyle(color: CupertinoColors.white)),
      ),
      child: tile,
    );
  }

  /// «Входящий (14 мин)» — тип звонка и, если разговор состоялся, длительность
  /// в скобках. Дата вынесена в правую часть строки (см. trailing).
  String _typeLine(BuildContext context, models.CallLog log) {
    final word = _directionWord(context, log);
    if (log.durationSeconds <= 0) return word;
    return '$word (${_humanDuration(context, log.durationSeconds)})';
  }

  Future<void> _confirmClear(BuildContext context) async {
    final cubit = context.read<CallsCubit>();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.screenCalls.clearTitle),
        content: Text(context.t.screenCalls.clearMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.t.screenCalls.clear),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.clearAll();
  }

  /// Фильтрация журнала по активному фильтру и строке поиска (по имени). Звонки
  /// со скрытыми собеседниками не показываются, пока их не раскроет «/код-фраза»
  /// (см. CallsCubit.search); раскрытые проходят мимо текстового фильтра — сам
  /// запрос в этот момент и есть код-фраза.
  List<models.CallLog> _visible(BuildContext context, CallsState state) {
    final utils = getIt.get<Utils>();
    final query = state.query.toLowerCase();
    return state.calls.where((log) {
      if (state.filter == CallsFilter.missed && !log.missed) return false;
      final hex = utils.bytesToHex(log.userID);
      if (state.hiddenHashByHex.containsKey(hex)) return state.revealedHex.contains(hex);
      if (query.isEmpty) return true;
      return _displayName(context, state, log).toLowerCase().contains(query);
    }).toList();
  }

  /// Имя собеседника: актуальное из кэша профилей ([CallsState.names]) с откатом
  /// на снимок из строки журнала, затем на «Неизвестный».
  String _displayName(BuildContext context, CallsState state, models.CallLog log) {
    final live = state.names[getIt.get<Utils>().bytesToHex(log.userID)];
    if (live != null && live.isNotEmpty) return live;
    if (log.displayName.isNotEmpty) return log.displayName;
    return context.t.screenCalls.unknown;
  }

  IconData _directionIcon(models.CallLog log) {
    if (log.missed) return CupertinoIcons.arrow_down_left;
    return log.direction == models.CallDirection.incoming ? CupertinoIcons.arrow_down_left : CupertinoIcons.arrow_up_right;
  }

  String _directionWord(BuildContext context, models.CallLog log) {
    final t = context.t.screenCalls;
    if (log.missed) return t.missed;
    if (log.direction == models.CallDirection.incoming) return t.incoming;
    // Исходящий без разговора (не дозвонились / нет сети / отмена) — «Отменённый».
    return log.durationSeconds > 0 ? t.outgoing : t.cancelled;
  }

  /// Человекочитаемая длительность: «10 сек», «14 мин», «1 час 30 мин».
  String _humanDuration(BuildContext context, int totalSeconds) {
    final t = context.t.screenCalls;
    if (totalSeconds < 60) return t.durationSec(s: totalSeconds);
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    if (h == 0) return t.durationMin(m: m);
    if (m == 0) return t.durationHour(h: h);
    return t.durationHourMin(h: h, m: m);
  }
}
