import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';

part '{name}[-c]_state.dart';
part '{name}[-c]_cubit.freezed.dart';

class {name}[-C]Cubit extends Cubit<{name}[-C]State> {
  {name}[-C]Cubit() : super(const {name}[-C]State());
}
