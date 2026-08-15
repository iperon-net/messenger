import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState());

  final logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(state.copyWith(status: Status.success));
  }


}
