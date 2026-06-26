import 'package:bloc/bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setDestinationSelectedIndex(int index) {
    emit(state.copyWith(destinationSelectedIndex: index));
  }

}
