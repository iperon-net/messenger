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

  /// Актуальные имена собеседников из кэша профилей: hex(userID) → имя. Имеют
  /// приоритет над снимком [models.CallLog.displayName] (профиль мог обновиться
  /// после звонка). Нет записи по userID — берём снимок, затем «Неизвестный».
  final Map<String, String> names;

  /// Локально скрытые профили: hex(userID) → sha256 код-фразы (hex). Звонки с
  /// такими собеседниками не показываются, пока не введена их код-фраза.
  final Map<String, String> hiddenHashByHex;

  /// Скрытые профили, раскрытые текущим запросом «/код-фраза» (hex(userID)).
  /// Видны в результатах только пока запрос активен. Считается в
  /// [CallsCubit.search], а не в build.
  final Set<String> revealedHex;

  /// Недостающие разрешения для звонков (пересчитываются без системного диалога,
  /// см. [CallsCubit.checkCallPermissions]). Микрофон нужен на обеих платформах;
  /// уведомления — только на Android (на iOS входящие ведёт CallKit).
  final bool callMicMissing;
  final bool callNotifMissing;

  /// Пользователь закрыл баннер-объяснение о разрешениях звонков в этой сессии
  /// (живёт только в памяти кубита; на следующем запуске напомнит снова).
  final bool bannerDismissed;

  /// Android-only: выключено ли разрешение Picture-in-Picture (мини-окно
  /// видеозвонка). Пересчитывается без диалога (см. [CallsCubit.checkPipPermission]).
  final bool pipMissing;

  /// Пользователь закрыл баннер PiP в этой сессии (в памяти кубита).
  final bool pipBannerDismissed;

  const CallsState({
    this.status = Status.initialization,
    this.calls = const [],
    this.query = "",
    this.filter = CallsFilter.all,
    this.names = const {},
    this.hiddenHashByHex = const {},
    this.revealedHex = const {},
    this.callMicMissing = false,
    this.callNotifMissing = false,
    this.bannerDismissed = false,
    this.pipMissing = false,
    this.pipBannerDismissed = false,
  });

  /// Показывать ли баннер-объяснение: чего-то не хватает и его ещё не закрыли.
  bool get showCallPermissionsBanner => (callMicMissing || callNotifMissing) && !bannerDismissed;

  /// Показывать ли баннер PiP: разрешение выключено, его не закрыли и обязательные
  /// разрешения (микрофон/уведомления) уже выданы — PiP-баннер идёт вторым, чтобы
  /// не показывать два баннера сразу.
  bool get showPipBanner => pipMissing && !pipBannerDismissed && !callMicMissing && !callNotifMissing;

  /// Есть ли хоть один пропущенный звонок — для показа/скрытия фильтра.
  bool get hasMissed => calls.any((c) => c.missed);
}
