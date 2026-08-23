import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

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

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    final avatar = await utils.boringAvatar(auth.session.getUserIDObjectID());
    logger.debug(avatar);

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

  Future<void> setProfile({DateTime? birthDate, required String firstName, required String lastName}) async {
    logger.debug("birthDate=$birthDate");
    // emit(state.copyWith(birthDate: birthDate));
  }
}
