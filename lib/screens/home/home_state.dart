import 'package:dart_mappable/dart_mappable.dart';

part 'home_state.mapper.dart';

@MappableClass()
class HomeState with HomeStateMappable {
  final int destinationSelectedIndex;
  final bool isAuth;

  const HomeState({this.destinationSelectedIndex = 0, this.isAuth = true});
}
