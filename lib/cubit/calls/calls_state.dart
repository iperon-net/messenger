import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'calls_state.mapper.dart';

/// Быстрый фильтр журнала: все звонки или только пропущенные.
@MappableEnum()
enum CallsFilter { all, missed }

/// Состояние вкладки «Звонки»: журнал недавних, строка поиска и активный фильтр.
/// Фильтрация по [query]/[filter] выполняется в экране (как на «Контактах»),
/// чтобы не гонять список через БД на каждый ввод.
@MappableClass()
class CallsState with CallsStateMappable {
  final Status status;
  final List<models.CallLog> calls;
  final String query;
  final CallsFilter filter;

  const CallsState({this.status = Status.initialization, this.calls = const [], this.query = "", this.filter = CallsFilter.all});

  /// Есть ли хоть один пропущенный звонок — для показа/скрытия фильтра.
  bool get hasMissed => calls.any((c) => c.missed);
}
