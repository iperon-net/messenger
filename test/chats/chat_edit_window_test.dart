import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/cubit/chat/chat_cubit.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/settings.dart';

/// Окно правки своего сообщения (04-edit-time-limit): сервер отклоняет правку
/// позже [Settings.chatEditWindow] (ClientConfig, часы), поэтому
/// `ChatCubit.canEdit` тем же сроком скрывает «Редактировать». Окна нет у
/// каналов (там права) и «Избранного» (не архивируется — правка без срока);
/// неотправленное (outbox) тоже правится — его на сервере ещё нет.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AccountScope scope;
  var scopeID = 0;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    scope = AccountScope('chat-edit-window-${scopeID++}');
    AccountScope.activate(scope);
  });

  tearDown(() async {
    await scope.dispose();
    AccountScope.activate(AccountScope(''));
    await getIt.reset();
  });

  void registerSettings(Duration window) => getIt.registerSingleton<Settings>(_FakeSettings(window));

  Future<ChatCubit> open(String chatID) async {
    final cubit = ChatCubit()..initialization(chatID: chatID, demo: true, markRead: false);
    addTearDown(cubit.close);
    await cubit.stream.firstWhere((state) => state.messages.isNotEmpty);
    return cubit;
  }

  /// Своё сообщение в демо-чате: отправка и ожидание появления.
  Future<models.Message> send(ChatCubit cubit, String text) async {
    expect(await cubit.send(text), isTrue);
    await cubit.stream.firstWhere((state) => state.messages.any((m) => m.text == text));
    return cubit.state.messages.firstWhere((m) => m.text == text);
  }

  /// То же сообщение, но [hours] часов назад (по умолчанию — за окном).
  models.Message aged(models.Message m, {int hours = 49}) => m.copyWith(date: DateTime.now().subtract(Duration(hours: hours)));

  test('в группе своё правится в окне и не правится после него', () async {
    registerSettings(const Duration(hours: 48));
    final id = await ChatsDemoDataSource.instance.createChat(type: models.ChatType.group, title: 'Окно правки');
    final cubit = await open(id);
    final message = await send(cubit, 'свежее');

    expect(cubit.canEdit(message), isTrue);
    expect(cubit.canEdit(aged(message)), isFalse);
  });

  test('окно берётся из Settings (ClientConfig), а не константой', () async {
    registerSettings(const Duration(hours: 1));
    final id = await ChatsDemoDataSource.instance.createChat(type: models.ChatType.group, title: 'Короткое окно');
    final cubit = await open(id);
    final message = await send(cubit, 'пару часов назад');

    // Старше короткого окна — уже нельзя.
    expect(cubit.canEdit(aged(message, hours: 2)), isFalse);

    // Широкое окно то же сообщение пропускает.
    await getIt.unregister<Settings>();
    registerSettings(const Duration(hours: 100));
    expect(cubit.canEdit(aged(message, hours: 49)), isTrue);
  });

  test('в канале окна нет — старый пост правится по правам', () async {
    registerSettings(const Duration(hours: 48));
    final id = await ChatsDemoDataSource.instance.createChat(type: models.ChatType.channel, title: 'Наш канал');
    final cubit = await open(id);
    final post = await send(cubit, 'старый пост');

    expect(cubit.canEdit(aged(post)), isTrue);
  });

  test('в «Избранном» окна нет — правится всегда', () async {
    registerSettings(const Duration(hours: 48));
    final cubit = await open('saved');
    final message = await send(cubit, 'заметка на будущее');

    expect(cubit.canEdit(aged(message, hours: 100)), isTrue);
  });

  test('неотправленное (outbox) окна не имеет', () async {
    registerSettings(const Duration(hours: 48));
    final id = await ChatsDemoDataSource.instance.createChat(type: models.ChatType.group, title: 'Outbox');
    final cubit = await open(id);
    final message = await send(cubit, 'ещё не ушло');

    final outbox = message.copyWith(id: localMessageID(42));
    expect(randomIDOfLocal(outbox.id), isNotNull);
    expect(cubit.canEdit(aged(outbox, hours: 100)), isTrue);
  });
}

final class _FakeSettings implements Settings {
  _FakeSettings(this.window);

  final Duration window;

  @override
  Duration get chatEditWindow => window;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
