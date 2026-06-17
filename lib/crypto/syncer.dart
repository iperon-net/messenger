part of 'crypto.dart';


enum MessageType {
  authRequest(1),
  authResponse(2);

  final int value;
  const MessageType(this.value);

  // Статический метод для получения enum по значению
  static MessageType fromValue(int value) {
    return values.firstWhere(
          (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }
}

class Header {
  final int version;
  final int length;
  final DateTime dateTime;
  final List<int> session;
  final List<int> sha256;
  final MessageType messageType;
  final int seq;
  final List<int> nonce;
  final List<int> header;

  Header({
    required this.version,
    required this.length,
    required this.dateTime,
    required this.session,
    required this.sha256,
    required this.messageType,
    required this.seq,
    required this.nonce,
    required this.header,
  });

  @override
  String toString () {
    return "version=$version, length=$length, dateTime=${dateTime.toIso8601String()}, messageType=$messageType, seq=$seq";
  }

}

class Syncer {
  final algorithmSha256 = Sha256();
  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  final logger = getIt.get<Logger>();

  // Future<List<int>> encodeProto({required models.Session session, required Uint8List message, required MessageType messageType, required int seq}) async {
  // }

  Future<List<int>> encode({required models.Session session, required Uint8List message, required MessageType messageType, required int seq}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final lengthByte = ByteData(4)..setUint32(0, message.length, Endian.big);
    final timestampByte = ByteData(8)..setUint64(0, timestamp, Endian.big);
    final messageTypeByte = ByteData(4)..setUint32(0, messageType.value, Endian.big);
    final seqByte = ByteData(4)..setUint32(0, seq, Endian.big);
    final hashSha256 = await algorithmSha256.hash(message);

    final nonce = algorithmAesGcm.newNonce();

    final bytesBuilder = BytesBuilder();
    bytesBuilder.add([1]);
    bytesBuilder.add(lengthByte.buffer.asUint8List());
    bytesBuilder.add(timestampByte.buffer.asUint8List());
    bytesBuilder.add(session.session);
    bytesBuilder.add(hashSha256.bytes);
    bytesBuilder.add(messageTypeByte.buffer.asUint8List());
    bytesBuilder.add(seqByte.buffer.asUint8List());
    bytesBuilder.add(nonce);

    final headerPadding = await padToSize(bytesBuilder.toBytes(), 128);

    final sharedKeyHkdf = await algorithmHkdf.deriveKey(
      secretKey: SecretKey(session.sharedKey),
      nonce: session.sharedSalt,
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

  Future<List<int>> decode({required models.Session session, required Uint8List message}) async {
    final headerPadding = message.sublist(0, 128);
    final header = await headerParse(message);

    final sharedKeyHkdf = await algorithmHkdf.deriveKey(
      secretKey: SecretKey(session.sharedKey),
      nonce: session.sharedSalt,
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
    if (!_listEquals(hashSha256.bytes, header.sha256)) {
      throw Exception('syncer: sha256 mismatch');
    }

    logger.debug(decrypted);

    return decrypted;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

   Future<Header> headerParse(Uint8List dataBytes) async {
     final version = dataBytes[0];
     final length = ByteData.sublistView(dataBytes, 1, 5).getUint32(0, Endian.big);
     final dateTime = DateTime.fromMillisecondsSinceEpoch(ByteData.sublistView(dataBytes, 5, 13).getUint64(0, Endian.big)).toUtc();
     final messageType = ByteData.sublistView(dataBytes, 77, 81).getUint32(0, Endian.big);
     final seq = ByteData.sublistView(dataBytes, 81, 85).getUint32(0, Endian.big);

     return Header(
       version: version,
       length: length,
       dateTime: dateTime,
       session: dataBytes.sublist(13,45),
       sha256: dataBytes.sublist(45,77),
       messageType: MessageType.fromValue(messageType),
       seq: seq,
       nonce: dataBytes.sublist(85,97),
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
      // Заполняем оставшуюся часть случайными байтами
      final random = Random.secure();
      for (int i = 0; i < remaining.length; i++) {
        remaining[i] = random.nextInt(256);
      }

      // Копируем обратно в padded (так как remaining - это новый список)
      padded.setRange(data.length, blockSize, remaining);

      return padded;
    } catch (e) {
      throw Exception('syncer: pad to size $e');
    }
  }

}
