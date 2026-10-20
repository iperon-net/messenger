import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/cubit/chat_create/chat_create_cubit.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/models.dart' as models;

/// Новая группа: «Скрыть историю» включено по умолчанию, тумблер доходит до
/// источника данных (демо).
void main() {
  final source = ChatsDemoDataSource.instance;

  Future<models.Chat> chat(String id) async => (await source.watchChats().first).firstWhere((c) => c.id == id);

  test('по умолчанию история скрыта', () async {
    final cubit = ChatCreateCubit();
    await cubit.initialization(demo: true, type: models.ChatType.group);
    expect(cubit.state.historyHidden, isTrue);
    await cubit.create(title: 'Скрытая история');
    final created = await chat(cubit.state.openChatID);
    expect(created.historyHidden, isTrue);
    await cubit.close();
  });

  test('тумблер при создании: история видна', () async {
    final cubit = ChatCreateCubit();
    await cubit.initialization(demo: true, type: models.ChatType.group);
    cubit.setHistoryHidden(false);
    await cubit.create(title: 'Открытая история');
    final created = await chat(cubit.state.openChatID);
    expect(created.historyHidden, isFalse);
    await cubit.close();
  });

  test('у канала история по умолчанию не скрыта', () async {
    final cubit = ChatCreateCubit();
    await cubit.initialization(demo: true, type: models.ChatType.channel);
    expect(cubit.state.historyHidden, isFalse);
    await cubit.close();
  });
}
