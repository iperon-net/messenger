import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../secure_storage.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final logger = getIt.get<Logger>();
  final secureStorage = getIt.get<SecureStorage>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String languageName = "English";
    if (LocaleSettings.currentLocale == AppLocale.ru) languageName = "Русский";

    emit(state.copyWith(
      versionApplication: packageInfo.version.toString(),
      languageName: languageName,
      status: Status.success,
    ));
  }

  Future<void> reloadLanguageName() async {
    emit(state.copyWith(status: Status.loading));

    String languageName = "English";
    if (LocaleSettings.currentLocale == AppLocale.ru) languageName = "Русский";

    emit(state.copyWith(languageName: languageName, status: Status.success));

  }


}
