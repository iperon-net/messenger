import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_profile_state.dart';

class SettingsProfileCubit extends Cubit<SettingsProfileState> {
  SettingsProfileCubit() : super(SettingsProfileState());

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
}
