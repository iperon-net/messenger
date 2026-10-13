import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/push.dart';

void main() {
  test('notification tap routes by kind', () {
    expect(PushManager.routeForKind(PushPayload_Kind.CONTACT_JOINED), '/contacts');
    expect(PushManager.routeForKind(PushPayload_Kind.CALL_MISSED), '/calls');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE), '/chats');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE_REACTION), '/chats');
    // Есть чат — в него.
    const chat = '0a1b2c3d4e5f60718293a4b5';
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE, chatID: chat), '/chats/chat/$chat');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE_REACTION, chatID: chat), '/chats/chat/$chat');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE, chatID: 'bad'), '/chats');
    expect(PushManager.routeForKind(PushPayload_Kind.TEST), isNull);
    expect(PushManager.routeForKind(null), isNull);
  });
}
