import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import 'settings_my_profile_username_state.dart';

enum UsernameValidationError { invalid }

class SettingsMyProfileUsernameCubit extends Cubit<SettingsMyProfileUsernameState> {
  SettingsMyProfileUsernameCubit() : super(SettingsMyProfileUsernameState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  /// Правила совпадают с серверными (`ServiceMyProfile.UpdateUsername`):
  /// 5–24 символа, только строчные латинские буквы, цифры и `_`.
  static final RegExp _pattern = RegExp(r'^[a-z0-9_]{5,24}$');

  Future<void> initialization({required AppLocale locale}) async {
    emit(state.copyWith(status: Status.loading, locale: locale));

    final myProfile = await repositories.myProfile.getByUserID(userID: auth.session.userID);
    if (isClosed) return;

    emit(state.copyWith(status: Status.success, username: myProfile.username));
  }

  /// Локальная валидация до отправки. Сервер всё равно приводит к нижнему
  /// регистру, поэтому проверяем нормализованное значение.
  UsernameValidationError? validate(String? value) {
    final username = (value ?? "").toLowerCase();
    if (!_pattern.hasMatch(username)) return UsernameValidationError.invalid;
    return null;
  }

  Future<void> setUsername({required String username}) async {
    final normalized = username.toLowerCase();

    if (validate(normalized) != null) {
      emit(state.copyWith(error: "screenMyProfile.usernameInvalid"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final status = await api.unaryEncoded(
      MessageType.MY_PROFILE_USERNAME_UPDATE,
      MyProfileUserNameUpdate_Request(username: normalized).writeToBuffer(),
    );
    if (isClosed) return;

    if (status.status == APIStatus.error) {
      // Сервер возвращает готовые i18n-ключи (`screenMyProfile.usernameInvalid`
      // / `screenMyProfile.usernameTaken`) в message ошибки; на прочие коды
      // показываем общий текст сохранения.
      final serverError = status.error;
      final error = (serverError == "screenMyProfile.usernameInvalid" || serverError == "screenMyProfile.usernameTaken")
          ? serverError
          : "screenMyProfile.errorSavingUsername";
      emit(state.copyWith(networkStatus: Status.success, error: error));
      return;
    }

    await repositories.myProfile.updateUsername(userID: auth.session.userID, username: normalized);
    if (isClosed) return;

    emit(state.copyWith(networkStatus: Status.success, username: normalized, redirectURI: Uri.parse("/settings/profile").toString()));
  }
}
