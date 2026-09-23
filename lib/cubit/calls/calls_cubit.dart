import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api.dart';
import '../../calls.dart';
import '../../components/call_permissions.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'calls_state.dart';

/// Кубит вкладки «Звонки». Читает локальный журнал звонков из БД и
/// перечитывает его, когда сервис [Calls] сообщает о новой записи ([Calls.callLogged])
/// — то есть после завершения любого звонка. Поиск и фильтр (все/пропущенные)
/// держит в состоянии; сами удаления идут в БД и триггерят перечитывание.
///
/// Имя собеседника в снимке [models.CallLog.displayName] мог устареть (профиль
/// изменился после звонка), поэтому актуальное имя резолвим «вживую» из кэша
/// профилей (как аватар в [UserAvatar]) в [CallsState.names] и обновляем по
/// приходящим `PROFILE`, пока вкладка открыта.
class CallsCubit extends Cubit<CallsState> {
  CallsCubit() : super(const CallsState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  final _calls = getIt.get<Calls>();

  StreamSubscription<void>? _sub;
  StreamSubscription<Uint8List>? _profileSub;
  StreamSubscription<void>? _hiddenSub;

  void initialization() {
    _sub = _calls.callLogged.listen((_) => load());
    // Обновление профиля собеседника (пришло по стриму или в ответ на запрос,
    // который шлёт, например, аватар в списке) — освежаем его имя в журнале.
    _profileSub = api.on(MessageType.PROFILE).listen(_onProfile);
    // Локально скрытые профили: читаем сразу и перечитываем по сигналу (профиль
    // скрыли/показали на отдельном экране — вкладка живёт в IndexedStack).
    _hiddenSub = repositories.hiddenProfiles.changes.listen((_) => _reloadHidden());
    _reloadHidden();
    load();
  }

  /// Перечитывает журнал из БД и резолвит актуальные имена из кэша профилей.
  Future<void> load() async {
    try {
      final calls = await repositories.callLogs.getAll();
      if (isClosed) return;
      final names = await _resolveNames(calls);
      if (isClosed) return;
      emit(state.copyWith(status: Status.success, calls: calls, names: names));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success));
    }
  }

  /// Актуальные имена (hex(userID) → имя) из кэша профилей по уникальным
  /// собеседникам журнала. В карту кладём только непустые имена — иначе UI сам
  /// откатится на снимок из строки, затем на «Неизвестный».
  Future<Map<String, String>> _resolveNames(List<models.CallLog> calls) async {
    final seen = <String>{};
    final names = <String, String>{};
    for (final log in calls) {
      final hex = utils.bytesToHex(log.userID);
      if (!seen.add(hex)) continue;
      try {
        final profile = await repositories.profiles.getByUserID(userID: log.userID);
        final phone = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
        var name = utils.composeDisplayName(
          firstName: profile.fistName,
          lastName: profile.lastName,
          phoneNumber: phone.international,
          username: profile.username,
        );
        // Профиль ещё не в кэше или без имени/номера — берём имя/номер из
        // адресной книги по этому userID (если контакт заведён).
        if (name.isEmpty) {
          final contact = await repositories.contacts.getByUserID(log.userID);
          if (contact != null) {
            name = contact.displayName.isNotEmpty ? contact.displayName : contact.phone;
          }
        }
        if (name.isNotEmpty) names[hex] = name;
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    return names;
  }

  /// Пришёл профиль — если этот собеседник есть в журнале, обновляем его имя.
  void _onProfile(Uint8List payload) {
    if (isClosed) return;
    final Profile_Response response;
    try {
      response = Profile_Response.fromBuffer(payload);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return;
    }
    // Собеседника нет в журнале — обновлять нечего.
    final present = state.calls.any((log) => listEquals(log.userID, response.userID));
    if (!present) return;
    final hex = utils.bytesToHex(Uint8List.fromList(response.userID));

    final phone = utils.phoneNormalization(phoneNumber: response.phoneNumber);
    final name = utils.composeDisplayName(
      firstName: response.firstName,
      lastName: response.lastName,
      phoneNumber: phone.international,
      username: response.username,
    );
    if (name.isEmpty || state.names[hex] == name) return;

    emit(state.copyWith(names: {...state.names, hex: name}));
  }

  /// Поиск + раскрытие скрытых по «/код-фразе». Асинхронный из-за sha256 фразы
  /// (считаем на ввод, не в build). Скрытый собеседник виден в журнале, только
  /// пока в поиске стоит его код-фраза.
  Future<void> search(String query) async {
    final revealed = await _revealedFor(query, state.hiddenHashByHex);
    if (isClosed) return;
    emit(state.copyWith(query: query, revealedHex: revealed));
  }

  void setFilter(CallsFilter filter) => emit(state.copyWith(filter: filter));

  /// hex(userID) скрытых профилей, чью код-фразу содержит запрос «/фраза».
  Future<Set<String>> _revealedFor(String query, Map<String, String> hidden) async {
    if (!query.startsWith('/') || hidden.isEmpty) return const {};
    final phrase = query.substring(1);
    if (phrase.trim().isEmpty) return const {};
    final hash = await utils.passphraseHash(phrase);
    return hidden.entries.where((e) => e.value == hash).map((e) => e.key).toSet();
  }

  /// Перечитывает набор скрытых профилей из БД и пересчитывает раскрытые под
  /// текущий запрос.
  Future<void> _reloadHidden() async {
    final entries = await repositories.hiddenProfiles.getAll();
    if (isClosed) return;
    final map = {for (final e in entries) utils.bytesToHex(Uint8List.fromList(e.userID)): e.phraseHash};
    final revealed = await _revealedFor(state.query, map);
    if (isClosed) return;
    emit(state.copyWith(hiddenHashByHex: map, revealedHex: revealed));
  }

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

  /// Пересчитывает недостающие разрешения для звонков БЕЗ системного диалога —
  /// только статусы (микрофон + уведомления на Android). Управляет показом
  /// баннера-объяснения на вкладке; вызывается при первом показе и после запроса.
  Future<void> checkCallPermissions() async {
    final mic = await Permission.microphone.status;
    if (isClosed) return;
    var notifMissing = false;
    if (Platform.isAndroid) {
      final notif = await Permission.notification.status;
      if (isClosed) return;
      notifMissing = !notif.isGranted;
    }
    emit(state.copyWith(callMicMissing: !mic.isGranted, callNotifMissing: notifMissing));
  }

  /// Кнопка «Разрешить» в баннере: запрашиваем недостающие разрешения строго
  /// последовательно (на Android два системных диалога сразу не показываются).
  /// Если система диалог уже не покажет (отклонено навсегда) — ведём в настройки.
  /// По завершении пересчитываем статусы, чтобы баннер скрылся при успехе.
  Future<void> requestCallPermissions() async {
    final mic = await Permission.microphone.status;
    if (isClosed) return;
    var openedSettings = false;
    if (!mic.isGranted) {
      if (mic.isPermanentlyDenied) {
        await openAppSettings();
        openedSettings = true;
      } else {
        await Permission.microphone.request();
      }
      if (isClosed) return;
    }
    // Уведомления — только Android. Настройки уже открыли под микрофон — второй
    // раз не дёргаем (перепроверим при возврате на вкладку). Запрашиваем через
    // permission_handler (а не callkit): его Future дожидается ответа пользователя
    // и возвращает свежий статус — иначе последующий checkCallPermissions читал бы
    // старый статус и баннер не исчезал бы сразу после выдачи.
    if (Platform.isAndroid && !openedSettings) {
      final notif = await Permission.notification.status;
      if (isClosed) return;
      if (!notif.isGranted) {
        if (notif.isPermanentlyDenied) {
          await openAppSettings();
        } else {
          await Permission.notification.request();
        }
        if (isClosed) return;
      }
    }
    await checkCallPermissions();
  }

  /// Пользователь закрыл баннер-объяснение о разрешениях звонков. Скрываем до
  /// конца сессии (в памяти кубита); историю звонков баннер и так не блокирует.
  void dismissCallBanner() {
    if (state.bannerDismissed) return;
    emit(state.copyWith(bannerDismissed: true));
  }

  /// Android-only: пересчитывает статус PiP-разрешения (без диалога) для показа
  /// PiP-баннера. Вызывается при первом показе вкладки и при возврате на передний
  /// план (после похода в системные настройки PiP).
  Future<void> checkPipPermission() async {
    if (!Platform.isAndroid) return;
    final granted = await isPipPermissionGranted();
    if (isClosed) return;
    emit(state.copyWith(pipMissing: !granted));
  }

  /// Кнопка «Открыть настройки» в PiP-баннере: PiP системным диалогом не
  /// запросить, ведём в системные настройки. Пересчёт статуса произойдёт при
  /// возврате на передний план (см. [checkPipPermission]).
  Future<void> openPipPermissionSettings() async {
    await openPipSettings();
  }

  /// Пользователь закрыл PiP-баннер. Скрываем до конца сессии (в памяти кубита).
  void dismissPipBanner() {
    if (state.pipBannerDismissed) return;
    emit(state.copyWith(pipBannerDismissed: true));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _profileSub?.cancel();
    _hiddenSub?.cancel();
    return super.close();
  }
}
