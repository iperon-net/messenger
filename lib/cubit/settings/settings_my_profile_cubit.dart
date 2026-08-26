import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_my_profile_state.dart';

enum FirstNameValidationError { maxLength }

enum LastNameValidationError { maxLength }

enum AboutMeValidationError { maxLength }

class SettingsMyProfileCubit extends Cubit<SettingsMyProfileState> {
  SettingsMyProfileCubit() : super(SettingsMyProfileState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<Uint8List>? _subscription;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Subscription
    _subscription = api.on(MessageType.MY_PROFILE).listen((payload) {
      if (isClosed) return;

      final response = MyProfile_Response.fromBuffer(payload);
      logger.debug(response.toString());

      emit(state.copyWith(firstName: response.firstName, lastName: response.lastName, aboutMe: response.aboutMe));

      if (response.birthDate.isNotEmpty) {
        emit(state.copyWith(birthDate: DateTime.parse(response.birthDate.toString())));
      }
    });

    // Send
    await api.sendEncoded(MessageType.MY_PROFILE, MyProfile_Request().writeToBuffer());
    if (isClosed) return;

    final avatar = await utils.boringAvatar(auth.session.getUserIDObjectID());

    emit(state.copyWith(status: Status.success, boringAvatarHash: avatar.hash, boringAvatarType: avatar.type));
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
    emit(state.copyWith(networkStatus: Status.loading));

    if (birthDate.isNotEmpty) {
      birthDate = DateTime.parse(birthDate).toIso8601String();
    }

    final status = await api.unaryEncoded(
      MessageType.MY_PROFILE_EDIT,
      MyProfileEdit_Request(firstName: firstName, lastName: lastName, aboutMe: aboutMe, birthDate: birthDate).writeToBuffer(),
    );

    logger.debug("status=$status");

    logger.debug("birthDate=$birthDate");
    logger.debug("firstName=$firstName");
    logger.debug("lastName=$lastName");
    logger.debug("aboutMe=$aboutMe");
    emit(state.copyWith(networkStatus: Status.success));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
