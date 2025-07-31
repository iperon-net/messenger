import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../logger.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final notificationStatus = await Permission.notification.status;

    _logger.debug(notificationStatus.toString());

    emit(state.copyWith(
      notificationStatus: notificationStatus,
      status: Status.success,
      privateBlur: true,
      versionApplication: packageInfo.version.toString()),
    );

  }

  Future<void> lifecycle() async {
    final notificationStatus = await Permission.notification.status;
    emit(state.copyWith(notificationStatus: notificationStatus, status: Status.success));
  }


}
