import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';

part 'privacy_and_security_cubit.freezed.dart';
part 'privacy_and_security_state.dart';

class PrivacyAndSecurityCubit extends Cubit<PrivacyAndSecurityState> {
  PrivacyAndSecurityCubit() : super(const PrivacyAndSecurityState());
}
