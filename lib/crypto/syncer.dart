part of 'crypto.dart';

class Syncer {
  final algorithmSha256 = Sha256();
  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  Future<List<int>> encode({required models.Session session, required Uint8List message}) async {
    final lengthByte = ByteData(4)..setUint32(0, message.length, Endian.big);
    final messageTypeByte = ByteData(4)..setUint32(0, 12, Endian.big);
    final hashSha256 = await algorithmSha256.hash(message);

    final sharedKeyHkdf = await algorithmHkdf.deriveKey(
      secretKey: SecretKey(session.sharedKey),
      nonce: session.sharedSalt,
      info: session.userID,
    );

    final bytesBuilder = BytesBuilder();
    bytesBuilder.add([1]);
    bytesBuilder.add(lengthByte.buffer.asUint8List());
    bytesBuilder.add(messageTypeByte.buffer.asUint8List());
    bytesBuilder.add(hashSha256.bytes);
    bytesBuilder.add(session.session);

    final nonce = algorithmAesGcm.newNonce();

    final secretBox = await algorithmAesGcm.encrypt(
      message,
      secretKey: sharedKeyHkdf,
      nonce: nonce,
      aad: bytesBuilder.toBytes(),
    );

    bytesBuilder.add(secretBox.concatenation());

    return bytesBuilder.toBytes();
  }

}
