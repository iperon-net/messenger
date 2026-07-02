import 'package:bloc/bloc.dart';

import '../../di.dart';
import '../../logger.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _logger = getIt.get<Logger>();

  HomeCubit() : super(const HomeState());

  void setDestinationSelectedIndex(int index) {
    emit(state.copyWith(destinationSelectedIndex: index));
  }

  @override
  Future<void> close() {
    _logger.debug("home cubit close");
    return super.close();
  }
}
