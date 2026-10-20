import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/components/chats/message_text.dart';
import 'package:messenger/cubit/chat_create/chat_create_cubit.dart';
import 'package:messenger/demo/chats_demo_data_source.dart';
import 'package:messenger/models.dart' as models;

/// «Запретить копирование» в группе: тумблер формы «Изменить» доходит до
/// источника данных (демо), а под защитой у блока кода нет «Копировать».
void main() {
  final source = ChatsDemoDataSource.instance;

  Future<models.Chat> chat(String id) async => (await source.watchChats().first).firstWhere((c) => c.id == id);

  test('«Изменить» → «Запретить копирование» → «Сохранить»: включает и выключает', () async {
    expect((await chat('team')).noForwards, isFalse);
    for (final enabled in [true, false]) {
      final cubit = ChatCreateCubit()..edit(demo: true, chat: await chat('team'));
      expect(cubit.state.noForwards, !enabled);
      cubit.setNoForwards(enabled);
      await cubit.save(title: cubit.state.title, about: cubit.state.about);
      expect(cubit.state.saved, isTrue);
      final saved = await chat('team');
      expect(saved.noForwards, enabled);
      expect(saved.noForwardsMine, isFalse);
      // Остальные поля формы не тронуты.
      expect(saved.title, 'Команда Iperon');
      await cubit.close();
    }
  });

  testWidgets('блок кода: «Копировать» только без защиты содержимого', (tester) async {
    Widget text({required bool protected}) => Directionality(
      textDirection: TextDirection.ltr,
      child: ChatContentProtection(
        protected: protected,
        child: MessageText(
          text: 'code',
          entities: const [models.MessageEntity(type: models.MessageEntityType.pre, offset: 0, length: 4)],
          style: const TextStyle(fontSize: 16),
          colors: const MessageTextColors(
            text: Color(0xFF000000),
            link: Color(0xFF0000FF),
            codeBackground: Color(0xFFEEEEEE),
            spoiler: Color(0xFF888888),
            quote: Color(0xFF0000FF),
          ),
        ),
      ),
    );
    Finder copy() => find.byType(FaIcon);

    await tester.pumpWidget(text(protected: false));
    expect(copy(), findsOneWidget);
    await tester.pumpWidget(text(protected: true));
    expect(copy(), findsNothing);
  });
}
