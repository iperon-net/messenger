import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/cubit/chat/chat_cubit.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;

/// Право удаления служебных плашек (02-delete-service-messages): убирает
/// администрация — даже свою плашку обычный участник не удаляет; в канале —
/// по правам канала (служебное — как чужое).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AccountScope scope;
  var scopeID = 0;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    scope = AccountScope('can-delete-service-${scopeID++}');
    AccountScope.activate(scope);
  });

  tearDown(() async {
    await scope.dispose();
    AccountScope.activate(AccountScope(''));
    await getIt.reset();
  });

  final demo = ChatsDemoDataSource.instance;

  Future<ChatCubit> open(String chatID) async {
    final cubit = ChatCubit()..initialization(chatID: chatID, demo: true, markRead: false);
    addTearDown(cubit.close);
    await cubit.stream.firstWhere((state) => state.messages.isNotEmpty);
    return cubit;
  }

  models.Message pill(ChatCubit cubit, {bool outgoing = false}) =>
      cubit.state.messages.firstWhere((m) => m.service && m.outgoing == outgoing);

  test('в группе чужую плашку writer не удаляет, владелец — удаляет', () async {
    final writer = await open('devs_chat');
    expect(writer.state.chat!.myRole, models.ChatRole.writer);
    expect(writer.canDelete(pill(writer)), isFalse);

    final owner = await open('coffee_staff');
    expect(owner.state.chat!.myRole, models.ChatRole.owner);
    expect(owner.canDelete(pill(owner)), isTrue);
  });

  test('свою служебную плашку обычный участник тоже не удаляет', () async {
    await demo.joinChat('devs_newbies'); // outgoing-плашка «Вы вступили в группу»
    final cubit = await open('devs_newbies');
    expect(cubit.state.chat!.myRole, models.ChatRole.writer);
    expect(cubit.canDelete(pill(cubit, outgoing: true)), isFalse);
  });

  test('в канале служебное — по праву удалять чужие: подписчик нет, владелец да', () async {
    await demo.joinChat('devs_jobs'); // outgoing-плашка «Вы подписались на канал»
    final reader = await open('devs_jobs');
    expect(reader.state.chat!.myRole, models.ChatRole.reader);
    expect(reader.canDelete(pill(reader, outgoing: true)), isFalse);

    final id = await demo.createChat(type: models.ChatType.channel, title: 'Наш канал');
    final owner = await open(id);
    expect(owner.canDelete(pill(owner, outgoing: true)), isTrue);
  });

  test('владелец удаляет служебную плашку (демо-источник)', () async {
    final cubit = await open('coffee_staff');
    final pill = cubit.state.messages.firstWhere((m) => m.service);
    expect(await cubit.delete(pill), isTrue);
    expect(cubit.state.messages.any((m) => m.id == pill.id), isFalse);
  });
}
