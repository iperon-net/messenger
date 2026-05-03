import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../../di.dart';
import '../../logger.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setDestinationSelectedIndex(int index) {
    emit(state.copyWith(destinationSelectedIndex: index));
  }

}
