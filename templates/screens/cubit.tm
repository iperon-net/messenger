import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';

part '{name}[-s]_state.dart';
part '{name}[-s]_cubit.freezed.dart';

class {name}[-C]Cubit extends Cubit<{name}[-C]State> {
  {name}[-C]Cubit() : super(const {name}[-C]State());
}
