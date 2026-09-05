import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:path/path.dart' as p;

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../upload.dart';
import '../../utils.dart';
import 'settings_my_profile_state.dart';

class SettingsMyProfileCubit extends Cubit<SettingsMyProfileState> {
  SettingsMyProfileCubit() : super(SettingsMyProfileState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization({required AppLocale locale}) async {
    emit(state.copyWith(status: Status.loading));

    // Subscription
    _subscription = api.on(MessageType.MY_PROFILE).listen((payload) {
      if (isClosed) return;

      final response = MyProfile_Response.fromBuffer(payload);

      emit(state.copyWith(firstName: response.firstName, lastName: response.lastName, aboutMe: response.aboutMe));

      if (response.hasBirthDate()) {
        emit(state.copyWith(birthDate: response.birthDate.toDateTime(toLocal: true)));
      }
    });

    final myProfileFuture = repositories.myProfile.getByUserID(userID: auth.session.userID);
    final userFuture = repositories.users.getBySession(session: auth.session);
    final sendFuture = api.sendEncoded(MessageType.MY_PROFILE, MyProfile_Request().writeToBuffer());

    final myProfile = await myProfileFuture;
    final user = await userFuture;
    await sendFuture;

    final phoneNormalization = utils.phoneNormalization(phoneNumber: user.phoneNumber);
    emit(
      state.copyWith(
        locale: locale,
        phoneNumber: phoneNormalization.international,
        firstName: myProfile.fistName,
        lastName: myProfile.lastName,
        birthDate: myProfile.birthDate,
        aboutMe: myProfile.aboutMe,
        boringAvatarHash: phoneNormalization.international,
      ),
    );

    if (isClosed) return;

    // emit(state.copyWith(locale: locate, phoneNumber: "+7 909 160 00 44"));
  }

  /// Перечитывает профиль из локальной БД и обновляет state.
  ///
  /// Экран профиля остаётся смонтированным, пока открыт экран редактирования,
  /// поэтому [initialization] после возврата повторно не вызывается. Экран
  /// правки дёргает этот метод по возвращении, чтобы показать только что
  /// сохранённые значения (БД уже обновлена в `SettingsMyProfileEditCubit`).
  Future<void> reload() async {
    final myProfile = await repositories.myProfile.getByUserID(userID: auth.session.userID);
    if (isClosed) return;

    emit(
      state.copyWith(
        firstName: myProfile.fistName,
        lastName: myProfile.lastName,
        birthDate: myProfile.birthDate,
        aboutMe: myProfile.aboutMe,
      ),
    );
  }

  /// Сохраняет обрезанный аватар как локальный превью и заливает его на
  /// сервер через [UploadManager] (этапы 1+2 — см.
  /// `docs/plans/client-media-upload-stage-1-2.md`). Привязка полученного
  /// `cdn_id` к профилю — отдельная, ещё не реализованная серверная задача
  /// (см. `shimmying-tumbling-owl.md`), поэтому пока просто логируем `CDN`.
  Future<void> setAvatar(Uint8List bytes) async {
    if (isClosed) return;

    emit(state.copyWith(error: "", avatarBytes: bytes));

    final uploadManager = getIt.get<UploadManager>();

    try {
      final tmpFile = await File(
        p.join(Directory.systemTemp.path, 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg'),
      ).writeAsBytes(bytes, flush: true);

      final cdn = await uploadManager.uploadFile(
        file: tmpFile,
        folder: 'avatars',
        contentType: 'image/jpeg',
        onProgress: (sent, total) {
          logger.debug('upload progress: $sent / $total');
        },
      );
      logger.debug(cdn.toString());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (isClosed) return;
      // Локальный превью (avatarBytes) уже показан выше — не откатываем его
      // из-за сбоя сети: пользователь продолжает видеть выбранную картинку,
      // просто получает сигнал, что сохранение на сервере не удалось.
      emit(state.copyWith(error: "screenMyProfile.errorSavingAvatar"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
