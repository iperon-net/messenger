import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../chats/chats_sync.dart' show ChatsOfflineException, ChatsFloodException;
import '../../chats/secret/secret_chats_sync.dart';
import '../../settings.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../peer_names.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../cdn.dart';
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

  /// [userID] — сырые байты ObjectID пользователя, чей профиль показываем.
  Future<void> initialization({required List<int> userID, required AppLocale locale}) async {
    emit(state.copyWith(status: Status.loading, locale: locale, userID: userID));

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
      boringAvatarHash: utils.bytesToHex(Uint8List.fromList(userID)),
    );
    // copyWith(avatarBytes: null) не отличает «не менять» от «обнулить», поэтому
    // аватар подставляем только когда он реально есть в кэше.
    if (avatarBytes != null) {
      next = next.copyWith(avatarBytes: avatarBytes);
    }
    next = next.copyWith(secretChatAvailable: await _secretChatAvailable(userID));
    if (isClosed) return;
    emit(next);

    // Отправку ждём в конце: она не должна задерживать показ кэша. Await сохраняем,
    // чтобы ошибка шифрования/отправки всплыла в лог, а не потерялась молча.
    await sendFuture;
  }

  /// «Начать секретный чат»: не себе, фича включена, при «только Premium» —
  /// у меня Premium (принять запрос может любой — это не про кнопку).
  Future<bool> _secretChatAvailable(List<int> userID) async {
    final settings = getIt.get<Settings>();
    final me = getIt.get<Auth>().session.userID;
    if (listEquals(me, userID) || !settings.secretChatsEnabled) return false;
    if (!settings.secretChatsPremiumOnly) return true;
    return repositories.myProfile.isPremium(userID: me);
  }

  /// Начать секретный чат: id нового чата (hex) или текст ошибки для показа.
  /// Нужна сеть — без неё сразу «Нет соединения».
  Future<({String? chatID, String? error})> startSecretChat(Translations t) async {
    if (state.secretChatStarting) return (chatID: null, error: null);
    emit(state.copyWith(secretChatStarting: true));
    try {
      final chatID = await SecretChatsSync.instance.create(state.userID);
      return (chatID: utils.bytesToHex(chatID), error: null);
    } on ChatsOfflineException {
      return (chatID: null, error: t.common.noConnectionTitle);
    } on ChatsFloodException {
      return (chatID: null, error: t.secretChat.errorFlood);
    } on SecretChatRequestException catch (error) {
      final ts = t.secretChat;
      final message = error.isPremiumRequired
          ? ts.errorPremiumRequired
          : error.isPeerUnsupported
          ? ts.errorPeerUnsupported
          : error.isDisabled
          ? ts.errorDisabled
          : error.isFrozen
          ? ts.errorFrozen
          : error.isPrivacyRestricted
          ? ts.errorPrivacyRestricted
          : ts.errorGeneric;
      return (chatID: null, error: message);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return (chatID: null, error: t.secretChat.errorGeneric);
    } finally {
      if (!isClosed) emit(state.copyWith(secretChatStarting: false));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
