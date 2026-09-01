import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_my_profile_edit_state.dart';

enum FirstNameValidationError { maxLength }

enum LastNameValidationError { maxLength }

enum AboutMeValidationError { maxLength }

class SettingsMyProfileEditCubit extends Cubit<SettingsMyProfileEditState> {
  SettingsMyProfileEditCubit() : super(SettingsMyProfileEditState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization({required AppLocale locale}) async {
    emit(state.copyWith(status: Status.loading, locale: locale));

    // Subscription
    _subscription = api.on(MessageType.MY_PROFILE).listen((payload) {
      if (isClosed) return;

      final response = MyProfile_Response.fromBuffer(payload);
      logger.debug(response.toString());

      emit(state.copyWith(firstName: response.firstName, lastName: response.lastName, aboutMe: response.aboutMe));

      if (response.hasBirthDate()) {
        emit(state.copyWith(birthDate: response.birthDate.toDateTime(toLocal: true)));
      }
    });

    // Send
    final sendFuture = api.sendEncoded(MessageType.MY_PROFILE, MyProfile_Request().writeToBuffer());
    if (isClosed) return;

    final myProfileFuture = repositories.myProfile.getByUserID(userID: auth.session.userID);

    final myProfile = await myProfileFuture;
    await sendFuture;

    final avatar = await utils.boringAvatar(auth.session.getUserIDObjectID());

    emit(
      state.copyWith(
        status: Status.success,
        firstName: myProfile.fistName,
        lastName: myProfile.lastName,
        birthDate: myProfile.birthDate,
        aboutMe: myProfile.aboutMe,
        boringAvatarHash: avatar.hash,
        boringAvatarType: avatar.type,
      ),
    );
  }

  FirstNameValidationError? validateFirstName(String? value) {
    if (value != null && value.length > 25) return FirstNameValidationError.maxLength;
    return null;
  }

  LastNameValidationError? validateLastName(String? value) {
    if (value != null && value.length > 25) return LastNameValidationError.maxLength;
    return null;
  }

  AboutMeValidationError? validateAboutMe(String? value) {
    if (value != null && value.length > 70) return AboutMeValidationError.maxLength;
    return null;
  }

  void setBirthDate(DateTime birthDate) {
    emit(state.copyWith(birthDate: birthDate));
  }

  void clearBirthDate() {
    emit(state.copyWith(birthDate: null));
  }

  void setAboutMeLength(int aboutMeLength) {
    emit(state.copyWith(aboutMeLength: aboutMeLength));
  }

  Future<void> setProfile({required String birthDate, required String firstName, required String lastName, required String aboutMe}) async {
    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final birthDateValue = birthDate.isNotEmpty ? DateTime.parse(birthDate) : null;

    final status = await api.unaryEncoded(
      MessageType.MY_PROFILE_UPDATE,
      MyProfileUpdate_Request(
        firstName: firstName,
        lastName: lastName,
        aboutMe: aboutMe,
        birthDate: birthDateValue != null ? Timestamp.fromDateTime(birthDateValue) : null,
      ).writeToBuffer(),
    );

    if (status.status == APIStatus.error) {
      logger.debug(status.status);
      emit(state.copyWith(networkStatus: Status.success, error: "screenMyProfile.errorSavingProfile"));
      return;
    }

    await repositories.myProfile.update(
      userID: auth.session.userID,
      fistName: firstName,
      lastName: lastName,
      aboutMe: aboutMe,
      birthDate: birthDateValue,
    );

    // redirectURI — сигнал экрану закрыть правку (pop). Обновление профиля берёт
    // на себя `SettingsMyProfileCubit.reload()`, вызываемый по возвращении: он
    // перечитывает только что записанную выше локальную БД.
    emit(state.copyWith(networkStatus: Status.success, redirectURI: Uri.parse("/settings/profile").toString()));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
