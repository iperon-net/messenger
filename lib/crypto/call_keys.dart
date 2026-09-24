part of 'crypto.dart';

/// Обмен ключом E2EE для звонка 1-на-1 поверх LiveKit.
///
/// LiveKit-SFU шифрует медиа-фреймы симметричным ключом комнаты (FrameCryptor,
/// GCM) — сам SFU этот ключ не знает и медиа расшифровать не может. Задача
/// [CallKeys] — дать обеим сторонам **одинаковый** 32-байтовый ключ комнаты, не
/// передавая его через сервер.
///
/// Схема (модель угроз: пассивный сервер + SAS в Фазе 2):
///   1. каждая сторона на звонок генерит эфемерную пару X25519 ([generateKeyPair]);
///   2. публичные ключи стороны обменивают внутри комнаты (data-канал LiveKit) —
///      публичный ключ не секрет, пассивный сервер, увидев оба, ничего не узнаёт
///      (стойкость ECDH); активную подмену закрывает SAS (safety number, Фаза 2);
///   3. каждая сторона выводит общий секрет ECDH и прогоняет его через HKDF-SHA256
///      с солью `callId` ([deriveRoomKey]) — из-за коммутативности ECDH ключ у
///      обеих сторон совпадает и жёстко привязан к конкретному звонку.
///
/// Ключ живёт только в памяти на время звонка; эфемерные пары после звонка
/// выбрасываются (forward secrecy). Ничего в БД не пишем.
class CallKeys {
  final Logger logger;

  CallKeys({required this.logger});

  final _x25519 = X25519();
  final _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
  final _sha256 = Sha256();

  /// Инфо-строка HKDF — доменное разделение ключа: привязывает вывод к назначению
  /// «ключ комнаты E2EE звонка» и к версии схемы (смена версии → несовместимый
  /// ключ, обе стороны обязаны обновиться).
  static const _roomKeyInfo = 'iperon-call-e2ee-v1';

  /// Метка домена для SAS (short authentication string) — чтобы вывод не совпадал
  /// с ключом комнаты. См. [deriveSas].
  static const _sasLabel = 'iperon-call-sas-v1';

  /// Алфавит SAS: ровно 64 различимых эмодзи (6 бит на символ). Порядок и состав —
  /// часть протокола: обе стороны обязаны иметь идентичный список, иначе увидят
  /// разные эмодзи при одном ключе. Менять только с бампом версии схемы.
  static const _sasAlphabet = <String>[
    '😀', '😎', '🤖', '👽', '🐶', '🐱', '🦊', '🦁', //
    '🐯', '🐼', '🐨', '🐸', '🐵', '🐔', '🐧', '🦉', //
    '🦄', '🐝', '🦋', '🐢', '🐙', '🐠', '🐬', '🐳', //
    '🌵', '🌲', '🍀', '🌸', '🌻', '🌈', '⭐', '🔥', //
    '🍎', '🍋', '🍉', '🍓', '🍒', '🍑', '🍍', '🥑', //
    '🍔', '🍕', '🌮', '🍩', '🍪', '🎂', '☕', '🍺', //
    '⚽', '🏀', '🎾', '🏆', '🎸', '🎺', '🎨', '🎯', //
    '🚗', '✈️', '🚀', '⛵', '⏰', '💡', '🔑', '🎁', //
  ];

  /// Генерирует эфемерную пару X25519 на один звонок.
  Future<SimpleKeyPair> generateKeyPair() => _x25519.newKeyPair();

  /// Публичный ключ пары в виде 32 сырых байт — то, что уходит собеседнику.
  Future<Uint8List> publicKeyBytes(SimpleKeyPair keyPair) async {
    final publicKey = await keyPair.extractPublicKey();
    return Uint8List.fromList(publicKey.bytes);
  }

  /// Выводит симметричный ключ комнаты E2EE (32 байта) из НАШЕЙ приватной пары и
  /// ПУБЛИЧНОГО ключа собеседника. `callId` служит солью HKDF — привязывает ключ к
  /// конкретному звонку (тот же обмен в другом звонке даст другой ключ). Обе
  /// стороны получают одинаковый результат: ECDH-секрет коммутативен, соль и info
  /// у них совпадают.
  ///
  /// Бросает, если [remotePublicKey] некорректной длины/формата — вызывающий
  /// трактует это как несогласованный ключ (звонок без E2EE-пометки).
  Future<Uint8List> deriveRoomKey({required SimpleKeyPair keyPair, required Uint8List remotePublicKey, required String callId}) async {
    if (remotePublicKey.length != 32) {
      throw ArgumentError('call e2ee: bad remote public key length ${remotePublicKey.length}');
    }
    final sharedSecret = await _x25519.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: SimplePublicKey(remotePublicKey, type: KeyPairType.x25519),
    );
    final roomKey = await _hkdf.deriveKey(secretKey: sharedSecret, nonce: utf8.encode(callId), info: utf8.encode(_roomKeyInfo));
    final bytes = await roomKey.extractBytes();
    return Uint8List.fromList(bytes);
  }

  /// Выводит SAS (short authentication string) из ключа комнаты — 4 эмодзи, которые
  /// собеседники сверяют голосом для защиты от активного MITM (сервер, подменивший
  /// публичные ключи, не сможет подогнать одинаковый SAS у обеих сторон). Оба конца
  /// имеют идентичный [roomKey] → видят одинаковые эмодзи.
  ///
  /// Берём хеш (метка домена ‖ roomKey), первые 3 байта = 24 бита → 4 индекса по
  /// 6 бит в [_sasAlphabet]. 24 бита ≈ 16.7M комбинаций — достаточно, чтобы подбор
  /// совпадающего SAS был непрактичен в реальном времени звонка.
  Future<List<String>> deriveSas(Uint8List roomKey) async {
    final input = <int>[...utf8.encode(_sasLabel), ...roomKey];
    final digest = await _sha256.hash(input);
    final b = digest.bytes;
    final bits = (b[0] << 16) | (b[1] << 8) | b[2];
    return [
      _sasAlphabet[(bits >> 18) & 0x3f],
      _sasAlphabet[(bits >> 12) & 0x3f],
      _sasAlphabet[(bits >> 6) & 0x3f],
      _sasAlphabet[bits & 0x3f],
    ];
  }
}
