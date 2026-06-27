import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../cubit/main_cubit.dart';
import '../../di.dart';
import '../../protobuf/messages.dart';
import '../../repositories/repositories.dart';
import '../../syncer.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final repositories = getIt.get<Repositories>();
  final syncer = getIt.get<Syncer>();


  Future<void> logout() async {
    final controller = syncer.getController();
    await syncer.auth.logoutRequest(controller: controller, seq: syncer.seq);
    emit(state.copyWith(logout: true));
  }

}
