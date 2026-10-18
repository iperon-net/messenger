part of 'crypto.dart';

/// Структуры секретного чата (E2EE): сообщения рукопожатия, состояние
/// храповика, заголовок конверта, паддинг и их сериализация. Логика — в
/// [SecretChatCrypto] (`secret_chat.dart`), план — `docs/plans/secret-chats-e2ee.md`.
///
/// Всё, что ждёт на диске (ожидающие рукопожатия, состояние храповика),
/// сериализуется в `toBytes()` (JSON с base64-полями и версией формата) — это
/// BLOB для SQLite. Сообщения рукопожатия по сети пойдут в proto (этап 2), здесь
/// они — просто наборы байт.

/// Ошибка секретного чата: подделка/повреждение, неверный коммитмент, сообщение
/// не по протоколу. Состояние, переданное в операцию, при ошибке не меняется.
class SecretChatException implements Exception {
  final String message;

  const SecretChatException(this.message);

  @override
  String toString() => 'SecretChatException: $message';
}

/// Сообщение уже расшифровано раньше (повтор доставки) — его можно молча
/// отбросить, это не атака и не рассинхрон.
class SecretChatDuplicateException extends SecretChatException {
  const SecretChatDuplicateException(super.message);
}

// Размеры ML-KEM-768 (FIPS 203).
const int _secretKemPublicKeySize = 1184;
const int _secretKemCiphertextSize = 1088;
const int _secretKeySize = 32;
const int _secretKemIdSize = 8;

String _b64(List<int> bytes) => base64.encode(bytes);

Uint8List _unb64(Object? value) {
  if (value is! String) throw const SecretChatException('state: bad field');
  return base64.decode(value);
}

Uint8List? _unb64OrNull(Object? value) => value == null ? null : _unb64(value);

Map<String, dynamic> _decodeJson(Uint8List bytes) {
  try {
    final value = jsonDecode(utf8.decode(bytes));
    if (value is Map<String, dynamic>) return value;
  } on FormatException {
    // ниже — общая ошибка
  }
  throw const SecretChatException('state: bad format');
}

/// 1. A → B: запрос на секретный чат. Несёт только коммитмент ключа A, сам ключ
/// A раскроет в [SecretChatCommit] — после того, как увидит ключ B.
class SecretChatRequest {
  final Uint8List commitment;

  const SecretChatRequest({required this.commitment});
}

/// 2. B → A: ответ устройства B — его эфемерный X25519 и публичный ML-KEM-768.
class SecretChatAccept {
  final Uint8List ephemeralKey;
  final Uint8List kemPublicKey;

  const SecretChatAccept({required this.ephemeralKey, required this.kemPublicKey});
}

/// 3. A → B: раскрытие коммитмента + инкапсуляция ML-KEM под ключ B + первый
/// ключ храповика A (B сразу делает по нему шаг и может писать первым).
class SecretChatCommit {
  final Uint8List ephemeralKey;
  final Uint8List nonce;
  final Uint8List kemCiphertext;
  final Uint8List ratchetKey;

  const SecretChatCommit({required this.ephemeralKey, required this.nonce, required this.kemCiphertext, required this.ratchetKey});
}

/// Отпечаток ключа секретного чата: [bytes] — для QR/hex на экране «Ключ
/// шифрования», [emoji] — короткая строка для сверки голосом/вживую. Одинаков у
/// обеих сторон, если сервер не подменил ключи. Не меняется при ML-KEM-rekey.
class SecretChatFingerprint {
  final Uint8List bytes;
  final List<String> emoji;

  const SecretChatFingerprint({required this.bytes, required this.emoji});

  String get hex => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Ожидающее рукопожатие инициатора (A): запрос отправлен, ждём [SecretChatAccept].
/// Может висеть днями (B не в сети) — хранится в БД.
class SecretChatInitiatorPending {
  final Uint8List ephemeralPrivate;
  final Uint8List ephemeralPublic;
  final Uint8List nonce;
  final Uint8List commitment;

  const SecretChatInitiatorPending({
    required this.ephemeralPrivate,
    required this.ephemeralPublic,
    required this.nonce,
    required this.commitment,
  });

  Uint8List toBytes() => utf8.encode(
    jsonEncode({'v': 1, 'ePriv': _b64(ephemeralPrivate), 'ePub': _b64(ephemeralPublic), 'nonce': _b64(nonce), 'commit': _b64(commitment)}),
  );

  factory SecretChatInitiatorPending.fromBytes(Uint8List bytes) {
    final json = _decodeJson(bytes);
    if (json['v'] != 1) throw const SecretChatException('state: unknown version');
    return SecretChatInitiatorPending(
      ephemeralPrivate: _unb64(json['ePriv']),
      ephemeralPublic: _unb64(json['ePub']),
      nonce: _unb64(json['nonce']),
      commitment: _unb64(json['commit']),
    );
  }
}

/// Ожидающее рукопожатие принявшего (B): ответ отправлен, ждём [SecretChatCommit].
class SecretChatResponderPending {
  final Uint8List chatId;
  final Uint8List commitment;
  final Uint8List ephemeralPrivate;
  final Uint8List ephemeralPublic;
  final Uint8List kemPublicKey;
  final Uint8List kemSecretKey;

  const SecretChatResponderPending({
    required this.chatId,
    required this.commitment,
    required this.ephemeralPrivate,
    required this.ephemeralPublic,
    required this.kemPublicKey,
    required this.kemSecretKey,
  });

  Uint8List toBytes() => utf8.encode(
    jsonEncode({
      'v': 1,
      'chatId': _b64(chatId),
      'commit': _b64(commitment),
      'ePriv': _b64(ephemeralPrivate),
      'ePub': _b64(ephemeralPublic),
      'kemPk': _b64(kemPublicKey),
      'kemSk': _b64(kemSecretKey),
    }),
  );

  factory SecretChatResponderPending.fromBytes(Uint8List bytes) {
    final json = _decodeJson(bytes);
    if (json['v'] != 1) throw const SecretChatException('state: unknown version');
    return SecretChatResponderPending(
      chatId: _unb64(json['chatId']),
      commitment: _unb64(json['commit']),
      ephemeralPrivate: _unb64(json['ePriv']),
      ephemeralPublic: _unb64(json['ePub']),
      kemPublicKey: _unb64(json['kemPk']),
      kemSecretKey: _unb64(json['kemSk']),
    );
  }
}

/// Итог рукопожатия: начальное состояние храповика + отпечаток для сверки.
class SecretChatSession {
  final SecretChatRatchetState state;
  final SecretChatFingerprint fingerprint;

  const SecretChatSession({required this.state, required this.fingerprint});
}

/// Результат [SecretChatCrypto.encrypt]: конверт для сервера + новое состояние.
/// Состояние сохранять в той же транзакции, что и исходящее сообщение.
class SecretChatEncrypted {
  final Uint8List envelope;
  final SecretChatRatchetState state;

  const SecretChatEncrypted({required this.envelope, required this.state});
}

/// Результат [SecretChatCrypto.decrypt]: открытый текст + новое состояние.
/// Состояние сохранять в той же транзакции, что и расшифрованное сообщение —
/// иначе краш между ними оставит храповик впереди сообщения (оно потеряно) или
/// позади (повтор не расшифруется).
class SecretChatDecrypted {
  final Uint8List plaintext;
  final SecretChatRatchetState state;

  const SecretChatDecrypted({required this.plaintext, required this.state});
}

/// Ключ ещё не пришедшего сообщения и когда он отложен (для TTL).
class SecretChatSkippedKey {
  final Uint8List messageKey;
  final int createdAt;

  const SecretChatSkippedKey(this.messageKey, this.createdAt);
}

/// Состояние Double Ratchet одной стороны секретного чата (+ ступенчатый
/// ML-KEM-rekey). Изменяемое, но операции [SecretChatCrypto] работают над
/// копией ([copy]) и возвращают новую — исходное при ошибке не портится.
class SecretChatRatchetState {
  /// Associated data всех сообщений — хеш транскрипта рукопожатия: привязывает
  /// шифротекст к этому чату и этому рукопожатию.
  Uint8List associatedData;
  Uint8List rootKey;
  Uint8List dhSendPrivate;
  Uint8List dhSendPublic;
  Uint8List? dhReceive;
  Uint8List? chainSend;
  Uint8List? chainReceive;
  int sendCount;
  int receiveCount;
  int previousSendCount;

  /// Пропущенные ключи сообщений (сообщение ещё не пришло, а следующие — да):
  /// `base64(dh):n` → ключ. Порядок вставки (map-литерал — LinkedHashMap) =
  /// порядок вытеснения.
  final Map<String, SecretChatSkippedKey> skipped;

  /// Наш ожидающий ML-KEM-ключ: объявлен в заголовках текущей отправляющей
  /// цепочки ([kemAdvertise]), ждём от собеседника инкапсуляцию под него.
  Uint8List? kemPublicKey;
  Uint8List? kemSecretKey;
  bool kemAdvertise;

  /// Наша инкапсуляция под ключ собеседника — уходит во всех заголовках текущей
  /// отправляющей цепочки (общий секрет уже подмешан в её вывод).
  Uint8List? kemCiphertext;
  Uint8List? kemCiphertextId;

  /// Сообщений (в обе стороны) и время с последнего подмешивания ML-KEM.
  int pqMessageCount;
  int pqAt;

  SecretChatRatchetState({
    required this.associatedData,
    required this.rootKey,
    required this.dhSendPrivate,
    required this.dhSendPublic,
    this.dhReceive,
    this.chainSend,
    this.chainReceive,
    this.sendCount = 0,
    this.receiveCount = 0,
    this.previousSendCount = 0,
    Map<String, SecretChatSkippedKey>? skipped,
    this.kemPublicKey,
    this.kemSecretKey,
    this.kemAdvertise = false,
    this.kemCiphertext,
    this.kemCiphertextId,
    this.pqMessageCount = 0,
    required this.pqAt,
  }) : skipped = skipped ?? <String, SecretChatSkippedKey>{};

  /// Можно ли уже отправлять (у B — сразу после [SecretChatCrypto.finish]).
  bool get canSend => chainSend != null;

  SecretChatRatchetState copy() => SecretChatRatchetState(
    associatedData: associatedData,
    rootKey: rootKey,
    dhSendPrivate: dhSendPrivate,
    dhSendPublic: dhSendPublic,
    dhReceive: dhReceive,
    chainSend: chainSend,
    chainReceive: chainReceive,
    sendCount: sendCount,
    receiveCount: receiveCount,
    previousSendCount: previousSendCount,
    skipped: Map.of(skipped),
    kemPublicKey: kemPublicKey,
    kemSecretKey: kemSecretKey,
    kemAdvertise: kemAdvertise,
    kemCiphertext: kemCiphertext,
    kemCiphertextId: kemCiphertextId,
    pqMessageCount: pqMessageCount,
    pqAt: pqAt,
  );

  Uint8List toBytes() => utf8.encode(
    jsonEncode({
      'v': 1,
      'ad': _b64(associatedData),
      'rk': _b64(rootKey),
      'dhsPriv': _b64(dhSendPrivate),
      'dhsPub': _b64(dhSendPublic),
      'dhr': dhReceive == null ? null : _b64(dhReceive!),
      'cks': chainSend == null ? null : _b64(chainSend!),
      'ckr': chainReceive == null ? null : _b64(chainReceive!),
      'ns': sendCount,
      'nr': receiveCount,
      'pn': previousSendCount,
      'skipped': [
        for (final entry in skipped.entries) {'id': entry.key, 'mk': _b64(entry.value.messageKey), 't': entry.value.createdAt},
      ],
      'kemPk': kemPublicKey == null ? null : _b64(kemPublicKey!),
      'kemSk': kemSecretKey == null ? null : _b64(kemSecretKey!),
      'kemAdv': kemAdvertise,
      'kemCt': kemCiphertext == null ? null : _b64(kemCiphertext!),
      'kemCtId': kemCiphertextId == null ? null : _b64(kemCiphertextId!),
      'pqCount': pqMessageCount,
      'pqAt': pqAt,
    }),
  );

  factory SecretChatRatchetState.fromBytes(Uint8List bytes) {
    final json = _decodeJson(bytes);
    if (json['v'] != 1) throw const SecretChatException('state: unknown version');
    final skipped = <String, SecretChatSkippedKey>{};
    for (final item in (json['skipped'] as List? ?? const [])) {
      final map = item as Map<String, dynamic>;
      skipped[map['id'] as String] = SecretChatSkippedKey(_unb64(map['mk']), map['t'] as int);
    }
    return SecretChatRatchetState(
      associatedData: _unb64(json['ad']),
      rootKey: _unb64(json['rk']),
      dhSendPrivate: _unb64(json['dhsPriv']),
      dhSendPublic: _unb64(json['dhsPub']),
      dhReceive: _unb64OrNull(json['dhr']),
      chainSend: _unb64OrNull(json['cks']),
      chainReceive: _unb64OrNull(json['ckr']),
      sendCount: json['ns'] as int,
      receiveCount: json['nr'] as int,
      previousSendCount: json['pn'] as int,
      skipped: skipped,
      kemPublicKey: _unb64OrNull(json['kemPk']),
      kemSecretKey: _unb64OrNull(json['kemSk']),
      kemAdvertise: json['kemAdv'] as bool,
      kemCiphertext: _unb64OrNull(json['kemCt']),
      kemCiphertextId: _unb64OrNull(json['kemCtId']),
      pqMessageCount: json['pqCount'] as int,
      pqAt: json['pqAt'] as int,
    );
  }
}

/// Заголовок сообщения храповика (открыт, но целиком входит в AAD):
///
///     flags u8 (bit0 — есть kemPk, bit1 — есть kemCt)
///     dh 32 | pn u32 BE | n u32 BE
///     [kemPk 1184]
///     [kemId 8 | kemCt 1088]
class SecretChatHeader {
  static const int _flagKemPublicKey = 0x01;
  static const int _flagKemCiphertext = 0x02;

  final Uint8List dh;
  final int previousCount;
  final int number;
  final Uint8List? kemPublicKey;
  final Uint8List? kemId;
  final Uint8List? kemCiphertext;

  const SecretChatHeader({
    required this.dh,
    required this.previousCount,
    required this.number,
    this.kemPublicKey,
    this.kemId,
    this.kemCiphertext,
  });

  Uint8List encode() {
    final builder = BytesBuilder(copy: false);
    var flags = 0;
    if (kemPublicKey != null) flags |= _flagKemPublicKey;
    if (kemCiphertext != null) flags |= _flagKemCiphertext;
    builder.addByte(flags);
    builder.add(dh);
    builder.add(
      (ByteData(8)
            ..setUint32(0, previousCount, Endian.big)
            ..setUint32(4, number, Endian.big))
          .buffer
          .asUint8List(),
    );
    if (kemPublicKey != null) builder.add(kemPublicKey!);
    if (kemCiphertext != null) {
      builder.add(kemId!);
      builder.add(kemCiphertext!);
    }
    return builder.toBytes();
  }

  factory SecretChatHeader.decode(Uint8List bytes) {
    const fixed = 1 + _secretKeySize + 8;
    if (bytes.length < fixed) throw const SecretChatException('header: too short');
    final flags = bytes[0];
    if (flags & ~(_flagKemPublicKey | _flagKemCiphertext) != 0) throw const SecretChatException('header: unknown flags');
    final hasPk = flags & _flagKemPublicKey != 0;
    final hasCt = flags & _flagKemCiphertext != 0;
    final expected = fixed + (hasPk ? _secretKemPublicKeySize : 0) + (hasCt ? _secretKemIdSize + _secretKemCiphertextSize : 0);
    if (bytes.length != expected) throw const SecretChatException('header: bad length');

    final counters = ByteData.sublistView(bytes, 1 + _secretKeySize, fixed);
    var offset = fixed;
    Uint8List? kemPublicKey;
    Uint8List? kemId;
    Uint8List? kemCiphertext;
    if (hasPk) {
      kemPublicKey = bytes.sublist(offset, offset + _secretKemPublicKeySize);
      offset += _secretKemPublicKeySize;
    }
    if (hasCt) {
      kemId = bytes.sublist(offset, offset + _secretKemIdSize);
      offset += _secretKemIdSize;
      kemCiphertext = bytes.sublist(offset, offset + _secretKemCiphertextSize);
    }
    return SecretChatHeader(
      dh: bytes.sublist(1, 1 + _secretKeySize),
      previousCount: counters.getUint32(0, Endian.big),
      number: counters.getUint32(4, Endian.big),
      kemPublicKey: kemPublicKey,
      kemId: kemId,
      kemCiphertext: kemCiphertext,
    );
  }
}

/// Паддинг открытого текста до бакета — скрывает длину сообщения от сервера.
/// ISO/IEC 7816-4: данные ‖ 0x80 ‖ нули. Бакеты: степени двойки от 256 байт до
/// 64 KiB, дальше — кратно 64 KiB.
class SecretChatPadding {
  static const int _minBucket = 256;
  static const int _largeStep = 64 * 1024;

  static int bucketFor(int length) {
    final needed = length + 1;
    if (needed > _largeStep) return ((needed + _largeStep - 1) ~/ _largeStep) * _largeStep;
    var bucket = _minBucket;
    while (bucket < needed) {
      bucket <<= 1;
    }
    return bucket;
  }

  static Uint8List pad(Uint8List data) {
    final padded = Uint8List(bucketFor(data.length));
    padded.setRange(0, data.length, data);
    padded[data.length] = 0x80;
    return padded;
  }

  static Uint8List unpad(Uint8List padded) {
    var index = padded.length - 1;
    while (index >= 0 && padded[index] == 0) {
      index--;
    }
    if (index < 0 || padded[index] != 0x80) throw const SecretChatException('padding: bad');
    return padded.sublist(0, index);
  }
}
