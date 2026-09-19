import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../calls.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../repositories/repositories.dart';
import 'calls_state.dart';

/// Кубит вкладки «Звонки». Читает локальный журнал звонков из БД и
/// перечитывает его, когда сервис [Calls] сообщает о новой записи ([Calls.callLogged])
/// — то есть после завершения любого звонка. Поиск и фильтр (все/пропущенные)
/// держит в состоянии; сами удаления идут в БД и триггерят перечитывание.
class CallsCubit extends Cubit<CallsState> {
  CallsCubit() : super(const CallsState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final _calls = getIt.get<Calls>();

  StreamSubscription<void>? _sub;

  void initialization() {
    _sub = _calls.callLogged.listen((_) => load());
    load();
  }

  /// Перечитывает журнал из БД.
  Future<void> load() async {
    try {
      final calls = await repositories.callLogs.getAll();
      if (isClosed) return;
      emit(state.copyWith(status: Status.success, calls: calls));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void setFilter(CallsFilter filter) => emit(state.copyWith(filter: filter));

  /// Удаляет одну запись журнала.
  Future<void> delete(models.CallLog log) async {
    try {
      await repositories.callLogs.deleteByID(log.id);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await load();
  }

  /// Очищает весь журнал.
  Future<void> clearAll() async {
    try {
      await repositories.callLogs.deleteAll();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await load();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
