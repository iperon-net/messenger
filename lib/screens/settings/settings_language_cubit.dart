import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/cubit/main_cubit.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';

part 'settings_language_state.dart';
part 'settings_language_cubit.freezed.dart';

class SettingsLanguageCubit extends Cubit<SettingsLanguageState> {
  SettingsLanguageCubit() : super(const SettingsLanguageState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  Future<void> setLocale(BuildContext context, {required AppLocale locate}) async {
    context.read<MainCubit>().setLocate(locate: locate);
    LocaleSettings.setLocale(locate);
    await repositories.settingsDevice.setLocate(locate: locate);
  }

}
