part of 'crypto.dart';

class Header {
  final int version;
  final int length;
  final DateTime dateTime;
  final List<int> session;
  final List<int> sha256;
  final List<int> nonce;
  final List<int> header;

  Header({
    required this.version,
    required this.length,
    required this.dateTime,
    required this.session,
    required this.sha256,
    required this.nonce,
    required this.header,
  });

  @override
  String toString () => "version=$version, length=$length, dateTime=${dateTime.toIso8601String()}";

}

class Syncer {
  final Logger logger;
  final Utils utils;

  Syncer({required this.logger, required this.utils});

  final algorithmSha256 = Sha256();
  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  Future<List<int>> encode({required Session session, required Uint8List message}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final lengthByte = ByteData(4)..setUint32(0, message.length, Endian.big);
    final timestampByte = ByteData(8)..setUint64(0, timestamp, Endian.big);

    final hashSha256 = await algorithmSha256.hash(message);

    final nonce = algorithmAesGcm.newNonce();

    final bytesBuilder = BytesBuilder();
    bytesBuilder.add([1]);
    bytesBuilder.add(lengthByte.buffer.asUint8List());
    bytesBuilder.add(timestampByte.buffer.asUint8List());
    bytesBuilder.add(session.session);
    bytesBuilder.add(hashSha256.bytes);
    bytesBuilder.add(nonce);

    final headerPadding = await padToSize(bytesBuilder.toBytes(), 128);

    final sharedKeyHkdf = await algorithmHkdf.deriveKey(
      secretKey: SecretKey(session.sharedKey),
      nonce: session.salt,
      info: headerPadding,
    );

    final secretBox = await algorithmAesGcm.encrypt(
      message,
      secretKey: sharedKeyHkdf,
      nonce: nonce,
      aad: headerPadding,
    );

    final bytesBuilderCrypt = BytesBuilder();
    bytesBuilderCrypt.add(headerPadding);
    bytesBuilderCrypt.add(secretBox.concatenation(nonce: false));
    return bytesBuilderCrypt.toBytes();
  }

  Future<List<int>> decode({required Session session, required Uint8List message}) async {
    final headerPadding = message.sublist(0, 128);
    final header = await headerParse(message);

    final sharedKeyHkdf = await algorithmHkdf.deriveKey(
      secretKey: SecretKey(session.sharedKey),
      nonce: session.salt,
      info: headerPadding,
    );

    final encryptedData = message.sublist(128);
    final cipherText = encryptedData.sublist(0, encryptedData.length - 16);
    final macBytes = encryptedData.sublist(encryptedData.length - 16);

    final secretBox = SecretBox(
      cipherText,
      nonce: header.nonce,
      mac: Mac(macBytes),
    );

    final decrypted = await algorithmAesGcm.decrypt(
      secretBox,
      secretKey: sharedKeyHkdf,
      aad: headerPadding,
    );

    final hashSha256 = await algorithmSha256.hash(Uint8List.fromList(decrypted));
    if (!constantTimeBytesEquality.equals(hashSha256.bytes, header.sha256)) {
      throw Exception('syncer: sha256 mismatch');
    }

    return decrypted;
  }

  Future<Header> headerParse(Uint8List dataBytes) async {
    final version = dataBytes[0];
    final length = ByteData.sublistView(dataBytes, 1, 5).getUint32(0, Endian.big);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(ByteData.sublistView(dataBytes, 5, 13).getUint64(0, Endian.big)).toUtc();

    return Header(
      version: version,
      length: length,
      dateTime: dateTime,
      session: dataBytes.sublist(13,45),
      sha256: dataBytes.sublist(45,77),
      nonce: dataBytes.sublist(77,89),
      header: dataBytes,
    );

  }

  Future<Uint8List> padToSize(Uint8List data, int blockSize) async {
    if (data.length >= blockSize) {
      return data.sublist(0, blockSize);
    }

    final padded = Uint8List(blockSize);
    padded.setRange(0, data.length, data);

    final remaining = padded.sublist(data.length);

    try {
      final random = Random.secure();
      for (int i = 0; i < remaining.length; i++) {
        remaining[i] = random.nextInt(256);
      }

      padded.setRange(data.length, blockSize, remaining);

      return padded;
    } catch (e) {
      throw Exception('syncer: pad to size $e');
    }
  }

}
