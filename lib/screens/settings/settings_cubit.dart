import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/protobuf/protos/messages/sessions_v1.pb.dart';

import '../../constants.dart';
import '../../cubit/main_cubit.dart';
import '../../di.dart';
import '../../protobuf/messages.dart';
import '../../repositories/repositories.dart';
import '../../syncer.dart';
import '../../crypto.dart' as crypto;
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final repositories = getIt.get<Repositories>();
  final syncer = getIt.get<Syncer>();

  Future<void> initialization(BuildContext context) async {
    await syncer.send(
      context, message: SessionsResponse().writeToBuffer(),
      messageType: SyncerMessageType.sessionsRequest,
    );
  }

  Future<void> logout(BuildContext context) async {
    await repositories.sessions.logout();
    if (context.mounted) {
      await syncer.send(
        context, message: LogoutRequest(action: LogoutAction.current).writeToBuffer(),
        messageType: SyncerMessageType.logoutRequest,
      );
    }
    if (context.mounted) context.read<MainCubit>().logout();
    if (context.mounted) context.go("/");
  }

}
