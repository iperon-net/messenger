import 'package:dart_mappable/dart_mappable.dart';

import '../constants.dart';

part 'common_state.mapper.dart';

@MappableClass()
class CommonState with CommonStateMappable {
  final Status status;
  const CommonState({this.status = Status.initialization});
}
