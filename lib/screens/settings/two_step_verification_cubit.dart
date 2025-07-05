import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';

part 'two_step_verification_cubit.freezed.dart';
part 'two_step_verification_state.dart';

class TwoStepVerificationCubit extends Cubit<TwoStepVerificationState> {
  TwoStepVerificationCubit() : super(const TwoStepVerificationState());
}
