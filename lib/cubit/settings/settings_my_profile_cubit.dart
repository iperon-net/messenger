import 'package:bloc/bloc.dart';

import 'settings_my_profile_state.dart';

class SettingsMyProfileCubit extends Cubit<SettingsMyProfileState> {
  SettingsMyProfileCubit() : super(SettingsMyProfileState());

  Future<void> initialization() async {}
}
