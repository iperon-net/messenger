import 'package:bloc/bloc.dart';
import 'package:messenger/i18n/translations.g.dart';

import 'settings_my_profile_state.dart';

class SettingsMyProfileCubit extends Cubit<SettingsMyProfileState> {
  SettingsMyProfileCubit() : super(SettingsMyProfileState());

  Future<void> initialization({required AppLocale locate}) async {
    emit(state.copyWith(locale: locate));
  }
}
