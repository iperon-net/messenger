import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
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
    emit(state.copyWith(status: Status.loading, locale: locale));

    // Слушаем PROFILE: сервер отвечает на наш запрос тем же типом. Фильтруем по
    // userID (в одном стриме могут прийти профили разных пользователей).
    _subscription = api.on(MessageType.PROFILE).listen((payload) async {
      if (isClosed) return;

      final response = Profile_Response.fromBuffer(payload);
      if (!listEquals(response.userID, userID)) return;

      final phoneNormalization = utils.phoneNormalization(phoneNumber: response.phoneNumber);
      emit(
        state.copyWith(
          status: Status.success,
          firstName: response.firstName,
          lastName: response.lastName,
          aboutMe: response.aboutMe,
          username: response.username,
          phoneNumber: phoneNormalization.international,
          birthDate: response.hasBirthDate() ? response.birthDate.toDateTime(toLocal: true) : null,
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
    await sendFuture;
    if (isClosed) return;

    final phoneNormalization = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
    emit(
      state.copyWith(
        firstName: profile.fistName,
        lastName: profile.lastName,
        aboutMe: profile.aboutMe,
        username: profile.username,
        phoneNumber: phoneNormalization.international,
        birthDate: profile.birthDate,
        boringAvatarHash: utils.bytesToHex(Uint8List.fromList(userID)),
      ),
    );

    // Аватар из кэша — мгновенно, без сети. Актуальную версию принесёт стрим выше.
    final avatarCdnID = profile.avatarCdnID;
    if (avatarCdnID != null && avatarCdnID.isNotEmpty) {
      try {
        final file = await cdnManager.cachedFile(Uint8List.fromList(avatarCdnID));
        if (isClosed) return;
        if (file != null) {
          emit(state.copyWith(avatarBytes: await file.readAsBytes()));
        }
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
