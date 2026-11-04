import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/cubit/chat/chat_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AccountScope scope;
  var scopeID = 0;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    scope = AccountScope('chat-cubit-${scopeID++}');
    AccountScope.activate(scope);
  });

  tearDown(() async {
    await scope.dispose();
    AccountScope.activate(AccountScope(''));
    await getIt.reset();
  });

  Future<ChatCubit> openChat() async {
    final cubit = ChatCubit()..initialization(chatID: 'saved', demo: true, markRead: false);
    addTearDown(cubit.close);
    await cubit.stream.firstWhere((state) => state.messages.isNotEmpty);
    return cubit;
  }

  test('отправка добавляет сообщение и очищает режим ответа', () async {
    final cubit = await openChat();
    cubit.startReply(cubit.state.messages.last);

    expect(await cubit.send('  **Новое** сообщение  '), isTrue);
    await cubit.stream.firstWhere((state) => state.messages.any((message) => message.text == 'Новое сообщение'));

    expect(cubit.state.reply, isNull);
    expect(cubit.state.messages.last.text, 'Новое сообщение');
    expect(cubit.state.messages.last.outgoing, isTrue);
  });

  test('правка сохраняет текст и выходит из режима редактирования', () async {
    final cubit = await openChat();
    final message = cubit.state.messages.last;

    cubit.startEdit(message);
    expect(cubit.state.editing?.id, message.id);
    expect(await cubit.send('исправлено'), isTrue);
    await cubit.stream.firstWhere((state) => state.messages.any((item) => item.id == message.id && item.text == 'исправлено'));

    expect(cubit.state.editing, isNull);
  });

  test('выделение удаляет только выбранные сообщения', () async {
    final cubit = await openChat();
    final removed = cubit.state.messages.last;
    final kept = cubit.state.messages.first;

    cubit.startSelection(removed);
    cubit.toggleSelected(kept);
    cubit.toggleSelected(kept);
    expect(cubit.state.selectedIDs, [removed.id]);

    expect(await cubit.deleteSelected(), isTrue);
    expect(cubit.state.messages.every((message) => message.id != removed.id), isTrue);
    expect(cubit.state.messages.any((message) => message.id == kept.id), isTrue);
    expect(cubit.state.selecting, isFalse);
  });

  test('локальный поиск находит сообщение и очищается', () async {
    final cubit = await openChat();
    final expected = cubit.state.messages.first;

    cubit.startSearch();
    cubit.setSearchQuery(expected.text);
    await cubit.stream.firstWhere((state) => state.searchResults.isNotEmpty);

    expect(cubit.state.searchResults, contains(expected.id));
    cubit.closeSearch();
    expect(cubit.state.searching, isFalse);
    expect(cubit.state.searchResults, isEmpty);
  });
}
