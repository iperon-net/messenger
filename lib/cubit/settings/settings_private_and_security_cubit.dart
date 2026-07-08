import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import 'settings_private_and_security_state.dart';

class SettingsPrivateAndSecurityCubit extends Cubit<SettingsPrivateAndSecurityState> {
  SettingsPrivateAndSecurityCubit() : super(const SettingsPrivateAndSecurityState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  Future<void> initialization() async {
  }

}
