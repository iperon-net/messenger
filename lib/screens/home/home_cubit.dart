import 'package:bloc/bloc.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../../di.dart';
import '../../logger.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setDestinationSelectedIndex(int index) {
    emit(state.copyWith(destinationSelectedIndex: index));
  }

}
