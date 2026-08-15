import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'home_state.mapper.dart';

@MappableClass()
class HomeState with HomeStateMappable {
  final Status status;

  const HomeState({
    this.status = Status.initialization,
  });
}
