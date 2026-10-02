import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/push.dart';

void main() {
  test('notification tap routes by kind', () {
    expect(PushManager.routeForKind(PushPayload_Kind.CONTACT_JOINED), '/contacts');
    expect(PushManager.routeForKind(PushPayload_Kind.CALL_MISSED), '/calls');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE), '/chats');
    expect(PushManager.routeForKind(PushPayload_Kind.TEST), isNull);
    expect(PushManager.routeForKind(null), isNull);
  });
}
