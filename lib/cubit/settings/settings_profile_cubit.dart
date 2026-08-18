import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'settings_profile_state.dart';

class SettingsProfileCubit extends Cubit<SettingsProfileState> {
  SettingsProfileCubit() : super(SettingsProfileState());

  final logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(state.copyWith(status: Status.success));
  }
}
