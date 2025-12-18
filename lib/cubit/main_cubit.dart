import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants.dart';

part 'main_cubit.freezed.dart';
part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState(loadingStatus: Status.initialization));

  Future<void> initState() async {
    emit(state.copyWith(loadingStatus: Status.loading, error: ""));
    await Future.delayed(Duration(milliseconds: 1000));
    emit(state.copyWith(loadingStatus: Status.success, error: "Слишком много символов в сообщение"));
  }

}
