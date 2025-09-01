import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../cubit/constants.dart';
import '../../di.dart';

part 'passcode_cubit.freezed.dart';
part 'passcode_state.dart';

class PasscodeCubit extends Cubit<PasscodeState> {
  PasscodeCubit() : super(const PasscodeState());

  final _repositories = getIt.get<Repositories>();

  Future<void> initialization() async {
    emit(state.copyWith(
      passCodeLock: 1,
    ));

    final settings = await _repositories.settingsDevice.getAllSettings();
    emit(state.copyWith(
      passCode: settings.passCode,
      passCodeTtl: settings.passCodeTtl,
      passCodeLock: 1,
      status: Status.success,
    ));
  }

  Future<void> setPassCodeTtl(String value) async {
    await _repositories.settingsDevice.setPassCodeTtl(int.parse(value));
    emit(state.copyWith(passCodeTtl: int.parse(value)));
  }

  Future<void> setPassCode(String value) async {
    await _repositories.settingsDevice.setPassCode(value);
    emit(state.copyWith(passCode: value));
  }

  Future<void> setPassCodeLock(int value) async {
    emit(state.copyWith(passCodeLock: value));
  }

  Future<void> disablePassCode() async {
    await _repositories.settingsDevice.setPassCode("");
    emit(state.copyWith(passCode: ""));
  }

}

