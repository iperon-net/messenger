import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';

part 'lock_cubit.freezed.dart';
part 'lock_state.dart';

class LockCubit extends Cubit<LockState> {
  LockCubit() : super(const LockState());


  void lock(BuildContext context) async {
    await screenLock(
      context: context,
      correctString: '1234',
      canCancel: false,
    );
  }

}
