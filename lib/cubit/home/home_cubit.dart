import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messenger/syncer.dart';

import '../../di.dart';
import '../../logger.dart';
import '../../streams.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _syncer = getIt.get<Syncer>();
  final _logger = getIt.get<Logger>();
  final _streams = getIt.get<Streams>();

  StreamSubscription<bool>? _authSubscription;

  HomeCubit() : super(const HomeState());

  void initialization() {
    _authSubscription ??= _streams.controllerAuth.stream.listen((isAuth) {
      emit(state.copyWith(isAuth: isAuth));
    });
  }

  void setDestinationSelectedIndex(int index) {
    emit(state.copyWith(destinationSelectedIndex: index));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _logger.debug("home cubit close");
    return super.close();
  }
}
