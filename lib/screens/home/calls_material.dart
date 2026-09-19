import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
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

/// Вкладка «Звонки» (Android): журнал недавних с аватаром, направлением (иконка),
/// длительностью и датой; пропущенные выделены красным. Сверху — поиск и быстрый
/// фильтр «Все/Пропущенные», свайп по строке удаляет запись, кнопка в аппбаре
/// очищает всю историю. Доступ к микрофону запрашиваем при первом показе (нужен
/// для звонков), но саму историю им не блокируем.
class CallsMaterial extends StatefulWidget {
  const CallsMaterial({super.key});

  @override
  State<CallsMaterial> createState() => _CallsMaterialState();
}

class _CallsMaterialState extends State<CallsMaterial> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Permission.microphone.request());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(context.t.screenCalls.title),
        actions: [
          BlocSelector<CallsCubit, CallsState, bool>(
            selector: (state) => state.calls.isNotEmpty,
            builder: (context, hasCalls) {
              if (!hasCalls) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: context.t.screenCalls.clear,
                onPressed: () => _confirmClear(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поле поиска — вне BlocBuilder, чтобы не терять фокус на каждый emit.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.t.screenCalls.search,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
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
                        child: SegmentedButton<CallsFilter>(
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment(value: CallsFilter.all, label: Text(context.t.screenCalls.filterAll)),
                            ButtonSegment(value: CallsFilter.missed, label: Text(context.t.screenCalls.filterMissed)),
                          ],
                          selected: {state.filter},
                          onSelectionChanged: (selection) => context.read<CallsCubit>().setFilter(selection.first),
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
          child: Text(text, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.builder(itemCount: items.length, itemBuilder: (context, index) => _tile(context, items[index]));
  }

  Widget _tile(BuildContext context, models.CallLog log) {
    final utils = getIt.get<Utils>();
    final hex = utils.bytesToHex(log.userID);
    final name = log.displayName.isNotEmpty ? log.displayName : context.t.screenCalls.unknown;
    final red = Theme.of(context).colorScheme.error;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;

    final tile = ListTile(
      leading: UserAvatar(userID: Uint8List.fromList(log.userID), placeholderName: hex),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: log.missed ? red : null),
      ),
      subtitle: Row(
        children: [
          Icon(_directionIcon(log), size: 16, color: log.missed ? red : secondary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              _subtitle(context, log),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: secondary),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(log.video ? Icons.videocam : Icons.call, color: Colors.green),
        onPressed: () => getIt.get<Calls>().startCall(toUserID: log.userID, video: log.video),
      ),
      onTap: () => context.push('/profile/$hex'),
    );

    return Dismissible(
      key: ValueKey('call_${log.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<CallsCubit>().delete(log),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(context.t.screenCalls.delete, style: const TextStyle(color: Colors.white)),
      ),
      child: tile,
    );
  }

  String _subtitle(BuildContext context, models.CallLog log) {
    final parts = <String>[_directionWord(context, log)];
    if (log.durationSeconds > 0) parts.add(_formatDuration(log.durationSeconds));
    parts.add(log.createdAt.relativeFormat(context.t));
    return parts.join(' · ');
  }

  Future<void> _confirmClear(BuildContext context) async {
    final cubit = context.read<CallsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.screenCalls.clearTitle),
        content: Text(context.t.screenCalls.clearMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(context.t.screenCalls.clear)),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.clearAll();
  }

  List<models.CallLog> _visible(BuildContext context, CallsState state) {
    final query = state.query.toLowerCase();
    return state.calls.where((log) {
      if (state.filter == CallsFilter.missed && !log.missed) return false;
      if (query.isEmpty) return true;
      final name = log.displayName.isNotEmpty ? log.displayName : context.t.screenCalls.unknown;
      return name.toLowerCase().contains(query);
    }).toList();
  }

  IconData _directionIcon(models.CallLog log) {
    if (log.missed) return Icons.call_missed;
    return log.direction == models.CallDirection.incoming ? Icons.call_received : Icons.call_made;
  }

  String _directionWord(BuildContext context, models.CallLog log) {
    final t = context.t.screenCalls;
    if (log.missed) return t.missed;
    if (log.direction == models.CallDirection.incoming) return t.incoming;
    // Исходящий без разговора (не дозвонились / нет сети / отмена) — «Отменённый».
    return log.durationSeconds > 0 ? t.outgoing : t.cancelled;
  }

  static String _formatDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
