import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';

void main() {
  final keys = CallKeys(logger: Logger());

  test('room key wraps for one participant and unwraps only by them', () async {
    final sender = await keys.generateKeyPair();
    final receiver = await keys.generateKeyPair();
    final stranger = await keys.generateKeyPair();
    final roomKey = Uint8List.fromList(List.generate(32, (i) => i));

    final wrapped = await keys.wrapRoomKey(
      keyPair: sender,
      remotePublicKey: await keys.publicKeyBytes(receiver),
      callId: 'c1',
      roomKey: roomKey,
    );
    final unwrapped = await keys.unwrapRoomKey(
      keyPair: receiver,
      remotePublicKey: await keys.publicKeyBytes(sender),
      callId: 'c1',
      wrapped: wrapped,
    );
    expect(unwrapped, roomKey);

    // Чужой ключ или другой звонок — MAC не сойдётся.
    await expectLater(
      keys.unwrapRoomKey(keyPair: stranger, remotePublicKey: await keys.publicKeyBytes(sender), callId: 'c1', wrapped: wrapped),
      throwsA(anything),
    );
    await expectLater(
      keys.unwrapRoomKey(keyPair: receiver, remotePublicKey: await keys.publicKeyBytes(sender), callId: 'c2', wrapped: wrapped),
      throwsA(anything),
    );
  });
}
