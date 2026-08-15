import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'chats_state.mapper.dart';

@MappableClass()
class ChatsState with ChatsStateMappable {
  final Status status;

  const ChatsState({
    this.status = Status.initialization,
  });
}
