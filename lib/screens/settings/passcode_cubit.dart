import 'package:bloc/bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../crypto/crypto.dart';
import '../../cubit/constants.dart';
import '../../di.dart';
import '../../logger.dart';

part 'passcode_cubit.freezed.dart';
part 'passcode_state.dart';

class PasscodeCubit extends Cubit<PasscodeState> {
  PasscodeCubit() : super(const PasscodeState());

  final _logger = getIt.get<Logger>();
  final _repositories = getIt.get<Repositories>();
  final _crypto = getIt.get<Crypto>();

  final inputController = InputController();

  Future<void> initialization() async {
    final settings = await _repositories.settingsDevice.getAllSettings();
    emit(state.copyWith(passCode: settings.passCode));
    _logger.debug(settings.toString());
  }

  Future<void> unlock() async {
    emit(state.copyWith(unlock: true));
  }

  Future<void> lock() async {
    emit(state.copyWith(unlock: false));
  }

  Future<void> savePassCode(String value) async {
    await _repositories.settingsDevice.setPassCode(value);
    emit(state.copyWith(passCode: value));
  }

  Future<void> disablePassCode() async {
    await _repositories.settingsDevice.setPassCode("");
    emit(state.copyWith(passCode: ""));
  }

}

