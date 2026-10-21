import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

void main() {
  late Translations t;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await LocaleSettings.setLocale(AppLocale.ru);
    t = await AppLocale.ru.build();
  });

  final session = idBytes('6716a2f0c1d2e3f4a5b6c7d8');
  pb.MessageSystemNotice login() => pb.MessageSystemNotice(
    kind: pb.MessageSystemNotice_Kind.NEW_LOGIN,
    sessionID: session,
    deviceModel: 'Pixel 9',
    os: 2,
    osVersion: '16',
    appVersion: '0.0.240',
    ip: '185.12.34.56',
    locationEnglish: 'Kazan, Russia',
    locationRussian: 'Казань, Россия',
    loginMethod: pb.MessageSystemNotice_LoginMethod.YANDEX,
  );

  test('новый вход: заголовок жирным, устройство, место, IP, способ, подсказка', () {
    final (:text, :entities) = systemNoticeText(t, login(), russian: true);
    expect(
      text,
      'Новый вход в аккаунт\n\n'
      'В ваш аккаунт вошли с нового устройства.\n\n'
      'Устройство: Pixel 9, Android 16\n'
      'Приложение: Iperon 0.0.240\n'
      'Место: Казань, Россия\n'
      'IP-адрес: 185.12.34.56\n'
      'Способ входа: Яндекс ID\n\n'
      '${t.systemNotice.notMeHint}',
    );
    expect(entities.single.type, models.MessageEntityType.bold);
    expect(entities.single.length, 'Новый вход в аккаунт'.length);
    expect(systemNoticeText(t, login(), russian: false).text, contains('Место: Kazan, Russia'));
  });

  test('без сессии и устройства — только что произошло', () {
    final notice = pb.MessageSystemNotice(kind: pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_RESET);
    expect(
      systemNoticeText(t, notice, russian: true).text,
      'Облачный пароль сброшен\n\nОблачный пароль сброшен по коду из письма и задан заново.',
    );
    final wrong = pb.MessageSystemNotice(kind: pb.MessageSystemNotice_Kind.CLOUD_PASSWORD_WRONG);
    expect(systemNoticeText(t, wrong, russian: true).text, endsWith(t.systemNotice.cloudPasswordWrongHint));
    final email = pb.MessageSystemNotice(kind: pb.MessageSystemNotice_Kind.RECOVERY_EMAIL_SET, email: 'k***@yandex.ru');
    expect(systemNoticeText(t, email, russian: true).text, contains('через k***@yandex.ru.'));
  });

  test('неизвестный вид (сервер новее) — «обновите приложение»', () {
    final notice = pb.MessageSystemNotice(kind: pb.MessageSystemNotice_Kind.UNKNOWN);
    final (:text, :entities) = systemNoticeText(t, notice, russian: true);
    expect(text, t.systemNotice.unknown);
    expect(entities, isEmpty);
  });

  test('сообщение и превью: обычный входящий пузырь с текстом уведомления', () {
    final message = pb.ChatMessage(
      chatID: idBytes('aaaaaaaaaaaaaaaaaaaaaaaa'),
      messageID: Int64(7),
      fromUserID: idBytes(models.systemUserID),
      date: Int64(1000),
      content: pb.MessageContent(systemNotice: login()),
    );
    final me = idBytes('bbbbbbbbbbbbbbbbbbbbbbbb');
    final model = messageFromPb(message, chatID: 'c', myUserID: me, readOutboxMaxID: 0, isSelf: false);
    expect(model.service, isFalse);
    expect(model.outgoing, isFalse);
    expect(model.text, startsWith('Новый вход в аккаунт\n\n'));
    expect(model.systemNotice?.kind, models.SystemNoticeKind.newLogin);
    expect(model.systemNotice?.sessionID, '6716a2f0c1d2e3f4a5b6c7d8');
    expect(model.systemNotice?.deviceModel, 'Pixel 9');
    // Непрочитанным считается, как на сервере.
    expect(skipsUnread(message.content), isFalse);

    final last = lastMessageFromPb(message, myUserID: me, readOutboxMaxID: 0, isSelf: false);
    expect(last.text, 'Новый вход в аккаунт');
  });

  test('чат «Iperon»: только читать', () {
    const chat = models.Chat(id: 'c', type: models.ChatType.private, title: 'Iperon', peerUserID: models.systemUserID);
    expect(chat.isSystem, isTrue);
    expect(chat.canPost, isFalse);
    const other = models.Chat(id: 'd', type: models.ChatType.private, title: 'Анна', peerUserID: 'cccccccccccccccccccccccc');
    expect(other.isSystem, isFalse);
    expect(other.canPost, isTrue);
  });
}
