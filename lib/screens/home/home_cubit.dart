import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setCupertinoTabIndex(int cupertinoTabIndex){
    emit(state.copyWith(cupertinoTabIndex: cupertinoTabIndex));
  }
}
