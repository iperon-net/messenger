import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../peer_names.dart';
import '../../privacy_blocks.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../cdn.dart';
import '../../chats/chats_mapping.dart';
import '../../chats/chats_presence.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../utils.dart';
import '../../models.dart' as models;
import 'profile_state.dart';

/// Экран публичного профиля чужого пользователя. Запрашивает профиль по userID
/// (или username), показывает кэш мгновенно и обновляет из стрима. Запись в БД и
/// скачивание аватара делает `API._handleMessage` — здесь только показ.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  final cdnManager = getIt.get<CDNManager>();

  StreamSubscription<Uint8List>? _subscription;
  StreamSubscription<void>? _presenceSubscription;
  StreamSubscription<Object?>? _contactsSubscription;
  StreamSubscription<void>? _blocksSubscription;
  Uint8List? _presenceUser;
  bool _demo = false;

  /// [userID] — сырые байты ObjectID пользователя, чей профиль показываем.
  /// [demo] — флаг «Демо чатов» (где искать личный чат); [chatID] — чат уже
  /// известен (профиль открыт из окна этого чата), искать не нужно.
  Future<void> initialization({required List<int> userID, required AppLocale locale, bool demo = false, String? chatID}) async {
    _demo = demo;
    emit(state.copyWith(status: Status.loading, locale: locale, userID: userID, chatID: chatID ?? '', chatResolved: chatID != null));
    if (chatID == null) unawaited(resolveChat());
    _watchPresence(Uint8List.fromList(userID));
    // Добавили / переименовали / удалили контакт (здесь или на другом
    // устройстве) — пересчитываем и имя в шапке.
    _contactsSubscription = repositories.db
        .onChange(['contacts'], triggerImmediately: false)
        .listen((_) => _readContact(refreshName: true));
    unawaited(_readContact());
    _blocksSubscription = PrivacyBlocks.changes().listen((_) => unawaited(_readBlocked()));
    unawaited(_readBlocked());
    unawaited(PrivacyBlocks.refreshOnce());

    // Слушаем PROFILE: сервер отвечает на наш запрос тем же типом. Фильтруем по
    // userID (в одном стриме могут прийти профили разных пользователей).
    _subscription = api.on(MessageType.PROFILE).listen((payload) async {
      if (isClosed) return;

      final response = Profile_Response.fromBuffer(payload);
      if (!listEquals(response.userID, userID)) return;

      final phoneNormalization = utils.phoneNormalization(phoneNumber: response.phoneNumber);
      final displayName = await peerDisplayName(userID, fresh: response);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: Status.success,
          displayName: displayName,
          firstName: response.firstName,
          lastName: response.lastName,
          aboutMe: response.aboutMe,
          username: response.username,
          phoneNumber: phoneNormalization.international,
          birthDate: response.hasBirthDate() ? response.birthDate.toDateTime(toLocal: true) : null,
          hideBirthYear: response.hideBirthYear,
          avatarThumbhash: response.hasAvatar() ? response.avatarThumbhash : '',
        ),
      );

      if (response.hasAvatar()) {
        try {
          final file = await cdnManager.download(cdn: models.CDN.fromProto(response.avatar));
          if (isClosed) return;
          emit(state.copyWith(avatarBytes: await file.readAsBytes()));
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }
    });

    // Кэш из БД + запрос на сервер параллельно.
    final profileFuture = repositories.profiles.getByUserID(userID: userID);
    final sendFuture = api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer());

    final profile = await profileFuture;
    if (isClosed) return;

    // Аватар из кэша читаем ДО первого emit, чтобы профиль и аватар нарисовались
    // ОДНИМ кадром. Иначе (текст отдельным emit, аватар — вторым) между ними
    // проскакивает кадр с `avatarBytes == null`, где рисуется BoringAvatar-
    // плейсхолдер, и он тут же сменяется картинкой — тот самый видимый «лаг на
    // несколько миллисекунд». На экране СВОЕГО профиля этого нет не потому, что
    // там быстрее, а потому что его кубит долгоживущий и avatarBytes уже лежит в
    // state с прошлого открытия; чужой профиль пушится заново каждый раз.
    // Читаем без сети (cachedFile); актуальную версию принесёт стрим выше.
    Uint8List? avatarBytes;
    final avatarCdnID = profile.avatarCdnID;
    if (avatarCdnID != null && avatarCdnID.isNotEmpty) {
      try {
        final file = await cdnManager.cachedFile(Uint8List.fromList(avatarCdnID));
        if (isClosed) return;
        if (file != null) {
          avatarBytes = await file.readAsBytes();
        }
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    if (isClosed) return;

    final phoneNormalization = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
    final displayName = await peerDisplayName(userID);
    if (isClosed) return;
    var next = state.copyWith(
      displayName: displayName,
      firstName: profile.fistName,
      lastName: profile.lastName,
      aboutMe: profile.aboutMe,
      username: profile.username,
      phoneNumber: phoneNormalization.international,
      birthDate: profile.birthDate,
      hideBirthYear: profile.hideBirthYear,
      avatarThumbhash: profile.avatarThumbhash,
      boringAvatarHash: utils.bytesToHex(Uint8List.fromList(userID)),
    );
    // copyWith(avatarBytes: null) не отличает «не менять» от «обнулить», поэтому
    // аватар подставляем только когда он реально есть в кэше.
    if (avatarBytes != null) {
      next = next.copyWith(avatarBytes: avatarBytes);
    }
    if (isClosed) return;
    emit(next);

    // Отправку ждём в конце: она не должна задерживать показ кэша. Await сохраняем,
    // чтобы ошибка шифрования/отправки всплыла в лог, а не потерялась молча.
    await sendFuture;
  }

  Future<void> _readBlocked() async {
    final blocked = await PrivacyBlocks.isBlocked(state.userID);
    if (!isClosed && blocked != state.blocked) emit(state.copyWith(blocked: blocked));
  }

  /// Заблокировать / разблокировать. Без сети / ошибка — `false` (экран
  /// показывает «нет соединения»); успех — кэш обновлён, [_readBlocked] сам.
  Future<bool> setBlocked(bool blocked) => PrivacyBlocks.setBlocked(state.userID, blocked);

  Future<void> _readContact({bool refreshName = false}) async {
    final entry = await repositories.contacts.getByUserID(state.userID);
    final name = entry == null || entry.displayName.trim() == entry.phone ? '' : entry.displayName.trim();
    final displayName = refreshName ? await peerDisplayName(state.userID) : state.displayName;
    if (isClosed) return;
    emit(
      state.copyWith(
        contactPhoneE164: entry?.phoneE164 ?? '',
        contactName: name,
        contactCloud: entry?.isCloud ?? false,
        displayName: displayName,
      ),
    );
  }

  /// Найти личный чат с пользователем в локальном кэше (без сервера) —
  /// при открытии и после «Сообщение» / удаления чата (он мог появиться или
  /// исчезнуть).
  Future<void> resolveChat() async {
    final source = chatsDataSource(demo: _demo);
    final chatID = source == null ? '' : await source.findPrivateChat(utils.bytesToHex(Uint8List.fromList(state.userID)));
    if (!isClosed) emit(state.copyWith(chatID: chatID, chatResolved: true));
  }

  /// «В сети» — спрашиваем при открытии и держим свежим, пока экран открыт
  /// (как окно личного чата); время захода [ChatsPresence] пишет в кэш
  /// профилей — читаем оттуда (видно и без сети).
  void _watchPresence(Uint8List userID) {
    _presenceUser = userID;
    ChatsPresence.instance.watch(userID);
    _presenceSubscription = ChatsPresence.instance.changed.listen((_) => _readPresence());
    unawaited(_readPresence());
  }

  Future<void> _readPresence() async {
    final userID = _presenceUser;
    if (userID == null) return;
    final lastSeen = await repositories.profiles.getLastSeenByUserIDs(userIDs: [userID], toHex: idHex);
    if (isClosed) return;
    final hex = idHex(userID);
    emit(state.copyWith(online: ChatsPresence.instance.isOnline(hex), lastSeen: lastSeen[hex]));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _presenceSubscription?.cancel();
    _contactsSubscription?.cancel();
    _blocksSubscription?.cancel();
    final userID = _presenceUser;
    if (userID != null) ChatsPresence.instance.unwatch(userID);
    return super.close();
  }
}
