import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/cubit/main_cubit.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../repositories/repositories.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final repositories = getIt.get<Repositories>();

  Future<void> logout(BuildContext context) async {
    await repositories.users.logout();
    if (context.mounted) context.read<MainCubit>().logout();
    if (context.mounted) context.go("/");
  }

}
