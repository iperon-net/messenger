import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
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

  Future<void> initialization({required AppLocale locate}) async {
    emit(state.copyWith(status: Status.loading));

    // Subscription
    _subscription = api.on(MessageType.MY_PROFILE).listen((payload) {
      if (isClosed) return;

      final response = MyProfile_Response.fromBuffer(payload);

      emit(state.copyWith(firstName: response.firstName, lastName: response.lastName, aboutMe: response.aboutMe));

      if (response.birthDate.isNotEmpty) {
        emit(state.copyWith(birthDate: DateTime.parse(response.birthDate.toString())));
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
        locale: locate,
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
