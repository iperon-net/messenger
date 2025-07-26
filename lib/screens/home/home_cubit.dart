import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../di.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final _notifications = getIt.get<Notifications>();

  Future<void> initialization() async {
    await _notifications.updateToken();

    final status = await Permission.notification.status;
    emit(state.copyWith(notificationPermissionStatus: status));
  }

  void setCupertinoTabIndex(int cupertinoTabIndex) {
    emit(state.copyWith(cupertinoTabIndex: cupertinoTabIndex));
  }
}
