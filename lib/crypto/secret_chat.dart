part of 'crypto.dart';

/// Крипто-ядро секретных чатов (E2EE 1-на-1, чат = пара устройств) — см.
/// `docs/plans/secret-chats-e2ee.md` §4.2–4.3. Сервер видит только непрозрачные
/// байты; здесь нет ни сети, ни БД — только преобразования «состояние + вход →
/// новое состояние + выход».
///
/// **Рукопожатие** (гибрид X25519 + ML-KEM-768, 3 сообщения, с коммитментом):
///   1. A [request]: эфемерный X25519 `eA`, случайный `nonceA`; отправляет только
///      `commit = SHA256(метка ‖ eA ‖ nonceA)`. chatId в коммитмент не входит — его
///      выдаёт сервер в ответ на этот же запрос; к чату ключи привязывают
///      транскрипт, `SK` и отпечаток (их обе стороны считают уже с chatId).
///   2. B [accept]: эфемерный X25519 `eB` + пара ML-KEM-768; отправляет `eB`, `kemPkB`.
///   3. A [complete]: инкапсулирует под `kemPkB` → `(kemCt, ssKem)`, `dh = X25519(eA, eB)`,
///      первый ключ храповика `a1`; отправляет `eA`, `nonceA`, `kemCt`, `a1`.
///   4. B [finish]: проверяет коммитмент, декапсулирует, считает то же.
///   `SK = HKDF(ikm = dh ‖ ssKem, salt = chatId, info = метка ‖ transcript)`.
///
/// **Отпечаток** (эмодзи) считается только из того, что зафиксировано до того, как
/// вторая сторона выбрала свой вклад: `eA`, `nonceA` (под коммитментом) и `eB`,
/// `kemPkB` (B выбрал их, не зная `eA`). Сервер-MITM, играющий B перед A, выбирает
/// свои ключи до раскрытия `eA`; играющий A перед B — зафиксировал `eA` коммитментом
/// до того, как увидел `eB`. Подогнать совпадающие эмодзи перебором нельзя, поэтому
/// хватает короткой строки (5 эмодзи = 30 бит). `kemCt` и `a1` в отпечаток не входят
/// (их A выбирает последним — их можно было бы перебирать): их подмена без подмены
/// X25519 даёт сторонам разные `SK`, то есть просто неработающий чат, а не MITM.
///
/// **Сообщения** — Double Ratchet по спецификации Signal (X25519 DH-храповик,
/// цепочки HMAC-SHA256, AES-256-GCM), AD = хеш транскрипта рукопожатия. Плюс
/// ступенчатая постквантовая подпитка корневого ключа (как перевыпуск ключа в
/// Telegram): раз в [pqRekeyMessages] сообщений или [pqRekeyInterval] сторона при
/// создании новой отправляющей цепочки объявляет свой ML-KEM-ключ во всех её
/// заголовках; собеседник на DH-шаге по этой цепочке инкапсулирует под него и
/// подмешивает секрет в вывод СВОЕЙ новой отправляющей цепочки (шифротекст — во
/// всех её заголовках); первая сторона декапсулирует на DH-шаге по ней и
/// подмешивает в соответствующий вывод принимающей цепочки. Порядок цепочек
/// Double Ratchet гарантирует, что подмешивание у обеих сторон совпадает.
///
/// Конверт: `version u8 ‖ headerLen u16 BE ‖ header ‖ AES-GCM(padded) ‖ tag`,
/// AAD = `AD ‖ version ‖ headerLen ‖ header`.
///
/// Операции над одним чатом вызывать строго последовательно (как `_locked` в
/// `ChatsSync`) и сохранять возвращённое состояние вместе с сообщением в одной
/// транзакции — иначе два параллельных шага разойдутся с собеседником.
class SecretChatCrypto {
  final Logger logger;

  SecretChatCrypto({required this.logger});

  static const int envelopeVersion = 1;

  /// Сколько ключей можно пропустить за одно сообщение (защита от «прыжка»
  /// номера, съедающего CPU/память).
  static const int maxSkip = 1000;

  /// Сколько пропущенных ключей храним всего (старые вытесняются).
  static const int maxSkippedKeys = 2000;

  /// Сколько храним пропущенный ключ (сообщение, видимо, потеряно).
  static const Duration skippedKeyTtl = Duration(days: 7);

  static const int pqRekeyMessages = 100;
  static const Duration pqRekeyInterval = Duration(days: 7);

  /// Длина эмодзи-отпечатка (по 6 бит на символ).
  static const int fingerprintEmojiCount = 5;

  static final _labelCommit = utf8.encode('iperon-secret-commit-v1');
  static final _labelTranscript = utf8.encode('iperon-secret-transcript-v1');
  static final _labelSk = utf8.encode('iperon-secret-sk-v1');
  static final _labelFingerprint = utf8.encode('iperon-secret-fingerprint-v1');
  static final _labelSas = utf8.encode('iperon-secret-sas-v1');
  static final _labelRoot = utf8.encode('iperon-secret-rk-v1');
  static final _labelMessage = utf8.encode('iperon-secret-msg-v1');

  final _x25519 = X25519();
  final _sha256 = Sha256();
  final _hmac = Hmac.sha256();
  final _aesGcm = AesGcm.with256bits();
  final _kem = PqcKem.kyber768;

  // ---------------------------------------------------------------------------
  // Рукопожатие
  // ---------------------------------------------------------------------------

  /// Шаг 1 (A): ключ и коммитмент для запроса (chatId сервер выдаст в ответ).
  Future<(SecretChatInitiatorPending, SecretChatRequest)> request() async {
    final (ephemeralPrivate, ephemeralPublic) = await _newDh();
    final nonce = Uint8List.fromList(randomBytes(_secretKeySize));
    final commitment = await _commitment(ephemeralPublic, nonce);
    return (
      SecretChatInitiatorPending(
        ephemeralPrivate: ephemeralPrivate,
        ephemeralPublic: ephemeralPublic,
        nonce: nonce,
        commitment: commitment,
      ),
      SecretChatRequest(commitment: commitment),
    );
  }

  /// Шаг 2 (B): принять запрос.
  Future<(SecretChatResponderPending, SecretChatAccept)> accept({required Uint8List chatId, required SecretChatRequest request}) async {
    _requireLength(request.commitment, _secretKeySize, 'commitment');
    final (ephemeralPrivate, ephemeralPublic) = await _newDh();
    final (kemPublicKey, kemSecretKey) = _kem.generateKeyPair();
    return (
      SecretChatResponderPending(
        chatId: chatId,
        commitment: request.commitment,
        ephemeralPrivate: ephemeralPrivate,
        ephemeralPublic: ephemeralPublic,
        kemPublicKey: kemPublicKey,
        kemSecretKey: kemSecretKey,
      ),
      SecretChatAccept(ephemeralKey: ephemeralPublic, kemPublicKey: kemPublicKey),
    );
  }

  /// Шаг 3 (A): по ответу B — сессия (можно сразу писать) + [SecretChatCommit] для B.
  /// [chatId] — идентификатор чата, выданный сервером на запрос.
  Future<(SecretChatSession, SecretChatCommit)> complete({
    required Uint8List chatId,
    required SecretChatInitiatorPending pending,
    required SecretChatAccept accept,
    DateTime? now,
  }) async {
    _requireLength(accept.ephemeralKey, _secretKeySize, 'ephemeral key');
    _requireLength(accept.kemPublicKey, _secretKemPublicKeySize, 'kem public key');

    final (kemCiphertext, kemSecret) = _kem.encapsulate(accept.kemPublicKey);
    final dh = await _dh(pending.ephemeralPrivate, pending.ephemeralPublic, accept.ephemeralKey);
    final (ratchetPrivate, ratchetPublic) = await _newDh();

    final transcript = await _transcript(
      chatId: chatId,
      commitment: pending.commitment,
      responderEphemeral: accept.ephemeralKey,
      responderKem: accept.kemPublicKey,
      initiatorEphemeral: pending.ephemeralPublic,
      nonce: pending.nonce,
      kemCiphertext: kemCiphertext,
      ratchetKey: ratchetPublic,
    );
    final sk = await _hkdf(ikm: [...dh, ...kemSecret], salt: chatId, info: [..._labelSk, ...transcript], length: _secretKeySize);

    // Double Ratchet, сторона A: dhr = eB (как signed prekey в Signal).
    final (rootKey, chainSend) = await _kdfRoot(sk, await _dh(ratchetPrivate, ratchetPublic, accept.ephemeralKey));
    final state = SecretChatRatchetState(
      associatedData: transcript,
      rootKey: rootKey,
      dhSendPrivate: ratchetPrivate,
      dhSendPublic: ratchetPublic,
      dhReceive: accept.ephemeralKey,
      chainSend: chainSend,
      pqAt: (now ?? DateTime.now()).millisecondsSinceEpoch,
    );

    final fingerprint = await _fingerprint(
      chatId: chatId,
      initiatorEphemeral: pending.ephemeralPublic,
      nonce: pending.nonce,
      responderEphemeral: accept.ephemeralKey,
      responderKem: accept.kemPublicKey,
    );

    return (
      SecretChatSession(state: state, fingerprint: fingerprint),
      SecretChatCommit(
        ephemeralKey: pending.ephemeralPublic,
        nonce: pending.nonce,
        kemCiphertext: kemCiphertext,
        ratchetKey: ratchetPublic,
      ),
    );
  }

  /// Шаг 4 (B): проверить раскрытие коммитмента и получить сессию.
  Future<SecretChatSession> finish({required SecretChatResponderPending pending, required SecretChatCommit commit, DateTime? now}) async {
    _requireLength(commit.ephemeralKey, _secretKeySize, 'ephemeral key');
    _requireLength(commit.nonce, _secretKeySize, 'nonce');
    _requireLength(commit.kemCiphertext, _secretKemCiphertextSize, 'kem ciphertext');
    _requireLength(commit.ratchetKey, _secretKeySize, 'ratchet key');

    final expected = await _commitment(commit.ephemeralKey, commit.nonce);
    if (!constantTimeBytesEquality.equals(expected, pending.commitment)) {
      throw const SecretChatException('handshake: commitment mismatch');
    }

    final kemSecret = _kem.decapsulate(pending.kemSecretKey, commit.kemCiphertext);
    final dh = await _dh(pending.ephemeralPrivate, pending.ephemeralPublic, commit.ephemeralKey);
    final transcript = await _transcript(
      chatId: pending.chatId,
      commitment: pending.commitment,
      responderEphemeral: pending.ephemeralPublic,
      responderKem: pending.kemPublicKey,
      initiatorEphemeral: commit.ephemeralKey,
      nonce: commit.nonce,
      kemCiphertext: commit.kemCiphertext,
      ratchetKey: commit.ratchetKey,
    );
    final sk = await _hkdf(ikm: [...dh, ...kemSecret], salt: pending.chatId, info: [..._labelSk, ...transcript], length: _secretKeySize);

    final at = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final state = SecretChatRatchetState(
      associatedData: transcript,
      rootKey: sk,
      dhSendPrivate: pending.ephemeralPrivate,
      dhSendPublic: pending.ephemeralPublic,
      pqAt: at,
    );
    // Сразу DH-шаг по первому ключу храповика A: у B появляются и принимающая
    // цепочка (сообщения A), и отправляющая — B может писать первым.
    await _dhRatchet(state, SecretChatHeader(dh: commit.ratchetKey, previousCount: 0, number: 0), at);

    final fingerprint = await _fingerprint(
      chatId: pending.chatId,
      initiatorEphemeral: commit.ephemeralKey,
      nonce: commit.nonce,
      responderEphemeral: pending.ephemeralPublic,
      responderKem: pending.kemPublicKey,
    );
    return SecretChatSession(state: state, fingerprint: fingerprint);
  }

  // ---------------------------------------------------------------------------
  // Сообщения
  // ---------------------------------------------------------------------------

  /// Шифрует [plaintext] (паддинг — внутри). [state] не меняется.
  Future<SecretChatEncrypted> encrypt({required SecretChatRatchetState state, required Uint8List plaintext}) async {
    if (!state.canSend) throw const SecretChatException('ratchet: no sending chain');
    final s = state.copy();

    final (chainKey, messageKey) = await _kdfChain(s.chainSend!);
    s.chainSend = chainKey;
    final header = SecretChatHeader(
      dh: s.dhSendPublic,
      previousCount: s.previousSendCount,
      number: s.sendCount,
      kemPublicKey: s.kemAdvertise ? s.kemPublicKey : null,
      kemId: s.kemCiphertext == null ? null : s.kemCiphertextId,
      kemCiphertext: s.kemCiphertext,
    );
    s.sendCount++;
    s.pqMessageCount++;

    final prefix = _envelopePrefix(header.encode());
    final (key, nonce) = await _messageKeys(messageKey);
    final box = await _aesGcm.encrypt(
      SecretChatPadding.pad(plaintext),
      secretKey: key,
      nonce: nonce,
      aad: [...s.associatedData, ...prefix],
    );

    return SecretChatEncrypted(envelope: Uint8List.fromList([...prefix, ...box.concatenation(nonce: false)]), state: s);
  }

  /// Расшифровывает конверт. [state] не меняется; при любой ошибке бросает
  /// [SecretChatException] ([SecretChatDuplicateException] — повтор доставки).
  Future<SecretChatDecrypted> decrypt({required SecretChatRatchetState state, required Uint8List envelope, DateTime? now}) async {
    final at = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final s = state.copy();

    if (envelope.length < 3) throw const SecretChatException('envelope: too short');
    if (envelope[0] != envelopeVersion) throw const SecretChatException('envelope: unknown version');
    final headerLength = ByteData.sublistView(envelope, 1, 3).getUint16(0, Endian.big);
    if (envelope.length < 3 + headerLength + 16) throw const SecretChatException('envelope: too short');
    final prefix = envelope.sublist(0, 3 + headerLength);
    final header = SecretChatHeader.decode(prefix.sublist(3));
    final cipher = envelope.sublist(prefix.length);
    final aad = [...s.associatedData, ...prefix];

    _purgeSkipped(s, at);

    final skippedId = _skippedId(header.dh, header.number);
    final skippedKey = s.skipped.remove(skippedId);
    if (skippedKey != null) {
      final plaintext = await _open(skippedKey.messageKey, cipher, aad);
      s.pqMessageCount++;
      return SecretChatDecrypted(plaintext: plaintext, state: s);
    }

    if (s.dhReceive == null || !constantTimeBytesEquality.equals(header.dh, s.dhReceive!)) {
      await _skipMessageKeys(s, header.previousCount, at);
      await _dhRatchet(s, header, at);
    } else if (header.number < s.receiveCount) {
      throw const SecretChatDuplicateException('ratchet: duplicate message');
    }

    await _skipMessageKeys(s, header.number, at);
    final (chainKey, messageKey) = await _kdfChain(s.chainReceive!);
    s.chainReceive = chainKey;
    s.receiveCount++;
    final plaintext = await _open(messageKey, cipher, aad);
    s.pqMessageCount++;
    return SecretChatDecrypted(plaintext: plaintext, state: s);
  }

  /// DH-шаг храповика по новому ключу собеседника [header.dh] (+ ML-KEM, если
  /// заголовок его несёт). Меняет [s] на месте — вызывается только над копией.
  Future<void> _dhRatchet(SecretChatRatchetState s, SecretChatHeader header, int at) async {
    s.previousSendCount = s.sendCount;
    s.sendCount = 0;
    s.receiveCount = 0;
    s.dhReceive = header.dh;

    // Ответ на наш объявленный ML-KEM-ключ: собеседник подмешал секрет в вывод
    // этой (его отправляющей) цепочки — подмешиваем в её принимающий вывод.
    Uint8List? receiveSecret;
    if (header.kemCiphertext != null) {
      final secretKey = s.kemSecretKey;
      if (secretKey == null || !constantTimeBytesEquality.equals(header.kemId!, await _kemId(s.kemPublicKey!))) {
        throw const SecretChatException('ratchet: unexpected kem ciphertext');
      }
      receiveSecret = _kem.decapsulate(secretKey, header.kemCiphertext!);
      s.kemPublicKey = null;
      s.kemSecretKey = null;
      s.kemAdvertise = false;
    }
    final (rootReceive, chainReceive) = await _kdfRoot(s.rootKey, [
      ...await _dh(s.dhSendPrivate, s.dhSendPublic, header.dh),
      ...?receiveSecret,
    ]);
    s.chainReceive = chainReceive;

    final (dhPrivate, dhPublic) = await _newDh();
    s.dhSendPrivate = dhPrivate;
    s.dhSendPublic = dhPublic;

    // Собеседник объявил ML-KEM-ключ — инкапсулируем и подмешиваем в нашу новую
    // отправляющую цепочку; шифротекст уйдёт во всех её заголовках.
    Uint8List? sendSecret;
    s.kemCiphertext = null;
    s.kemCiphertextId = null;
    if (header.kemPublicKey != null) {
      final (ciphertext, secret) = _kem.encapsulate(header.kemPublicKey!);
      s.kemCiphertext = ciphertext;
      s.kemCiphertextId = await _kemId(header.kemPublicKey!);
      sendSecret = secret;
    }
    final (rootSend, chainSend) = await _kdfRoot(rootReceive, [...await _dh(dhPrivate, dhPublic, header.dh), ...?sendSecret]);
    s.rootKey = rootSend;
    s.chainSend = chainSend;

    if (receiveSecret != null || sendSecret != null) {
      s.pqMessageCount = 0;
      s.pqAt = at;
    }

    // Свой rekey: объявляем новый ML-KEM-ключ в этой цепочке, если пора и в этом
    // шаге секрет уже не подмешивался. Ещё не отвеченный ключ объявляем дальше.
    if (s.kemSecretKey != null) {
      s.kemAdvertise = true;
    } else if (receiveSecret == null && sendSecret == null && _pqDue(s, at)) {
      final (publicKey, secretKey) = _kem.generateKeyPair();
      s.kemPublicKey = publicKey;
      s.kemSecretKey = secretKey;
      s.kemAdvertise = true;
    } else {
      s.kemAdvertise = false;
    }
  }

  bool _pqDue(SecretChatRatchetState s, int at) => s.pqMessageCount >= pqRekeyMessages || at - s.pqAt >= pqRekeyInterval.inMilliseconds;

  Future<void> _skipMessageKeys(SecretChatRatchetState s, int until, int at) async {
    final chain = s.chainReceive;
    if (chain == null || s.dhReceive == null) return;
    if (until - s.receiveCount > maxSkip) throw const SecretChatException('ratchet: too many skipped messages');
    var chainKey = chain;
    while (s.receiveCount < until) {
      final (next, messageKey) = await _kdfChain(chainKey);
      chainKey = next;
      s.skipped[_skippedId(s.dhReceive!, s.receiveCount)] = SecretChatSkippedKey(messageKey, at);
      s.receiveCount++;
    }
    s.chainReceive = chainKey;
    while (s.skipped.length > maxSkippedKeys) {
      s.skipped.remove(s.skipped.keys.first);
    }
  }

  void _purgeSkipped(SecretChatRatchetState s, int at) {
    s.skipped.removeWhere((_, value) => at - value.createdAt > skippedKeyTtl.inMilliseconds);
  }

  String _skippedId(Uint8List dh, int number) => '${base64.encode(dh)}:$number';

  // ---------------------------------------------------------------------------
  // Примитивы
  // ---------------------------------------------------------------------------

  Uint8List _envelopePrefix(Uint8List header) {
    final prefix = Uint8List(3 + header.length);
    prefix[0] = envelopeVersion;
    ByteData.sublistView(prefix, 1, 3).setUint16(0, header.length, Endian.big);
    prefix.setRange(3, prefix.length, header);
    return prefix;
  }

  Future<Uint8List> _open(Uint8List messageKey, Uint8List cipher, List<int> aad) async {
    final (key, nonce) = await _messageKeys(messageKey);
    final box = SecretBox(cipher.sublist(0, cipher.length - 16), nonce: nonce, mac: Mac(cipher.sublist(cipher.length - 16)));
    try {
      final plaintext = await _aesGcm.decrypt(box, secretKey: key, aad: aad);
      return SecretChatPadding.unpad(Uint8List.fromList(plaintext));
    } on SecretBoxAuthenticationError {
      throw const SecretChatException('ratchet: authentication failed');
    }
  }

  /// Ключ сообщения → ключ AES-256 + nonce. Ключ сообщения одноразовый, поэтому
  /// детерминированный nonce безопасен.
  Future<(SecretKey, List<int>)> _messageKeys(Uint8List messageKey) async {
    final bytes = await _hkdf(ikm: messageKey, salt: Uint8List(_secretKeySize), info: _labelMessage, length: 44);
    return (SecretKey(bytes.sublist(0, 32)), bytes.sublist(32));
  }

  /// KDF_RK: (rk, dhOut) → (rk', ck).
  Future<(Uint8List, Uint8List)> _kdfRoot(Uint8List rootKey, List<int> input) async {
    final bytes = await _hkdf(ikm: input, salt: rootKey, info: _labelRoot, length: 64);
    return (bytes.sublist(0, 32), bytes.sublist(32));
  }

  /// KDF_CK: ck → (ck', mk).
  Future<(Uint8List, Uint8List)> _kdfChain(Uint8List chainKey) async {
    final secret = SecretKey(chainKey);
    final messageKey = await _hmac.calculateMac(const [0x01], secretKey: secret);
    final next = await _hmac.calculateMac(const [0x02], secretKey: secret);
    return (Uint8List.fromList(next.bytes), Uint8List.fromList(messageKey.bytes));
  }

  Future<Uint8List> _hkdf({required List<int> ikm, required List<int> salt, required List<int> info, required int length}) async {
    final hkdf = Hkdf(hmac: _hmac, outputLength: length);
    final key = await hkdf.deriveKey(secretKey: SecretKey(ikm), nonce: salt, info: info);
    return Uint8List.fromList(await key.extractBytes());
  }

  Future<(Uint8List, Uint8List)> _newDh() async {
    final keyPair = await _x25519.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();
    return (Uint8List.fromList(privateKey), Uint8List.fromList(publicKey.bytes));
  }

  Future<Uint8List> _dh(Uint8List privateKey, Uint8List publicKey, Uint8List remote) async {
    _requireLength(remote, _secretKeySize, 'dh public key');
    final keyPair = SimpleKeyPairData(
      privateKey,
      publicKey: SimplePublicKey(publicKey, type: KeyPairType.x25519),
      type: KeyPairType.x25519,
    );
    final shared = await _x25519.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: SimplePublicKey(remote, type: KeyPairType.x25519),
    );
    final bytes = Uint8List.fromList(await shared.extractBytes());
    // Ключ малого порядка даёт нулевой секрет — отвергаем.
    if (bytes.every((b) => b == 0)) throw const SecretChatException('dh: low-order public key');
    return bytes;
  }

  Future<Uint8List> _kemId(Uint8List kemPublicKey) async {
    final hash = await _sha256.hash(kemPublicKey);
    return Uint8List.fromList(hash.bytes.sublist(0, _secretKemIdSize));
  }

  Future<Uint8List> _commitment(Uint8List ephemeral, Uint8List nonce) async {
    final hash = await _sha256.hash([..._labelCommit, ...ephemeral, ...nonce]);
    return Uint8List.fromList(hash.bytes);
  }

  Future<Uint8List> _transcript({
    required Uint8List chatId,
    required Uint8List commitment,
    required Uint8List responderEphemeral,
    required Uint8List responderKem,
    required Uint8List initiatorEphemeral,
    required Uint8List nonce,
    required Uint8List kemCiphertext,
    required Uint8List ratchetKey,
  }) async {
    final hash = await _sha256.hash([
      ..._labelTranscript,
      ..._lengthPrefixed(chatId),
      ...commitment,
      ...responderEphemeral,
      ...responderKem,
      ...initiatorEphemeral,
      ...nonce,
      ...kemCiphertext,
      ...ratchetKey,
    ]);
    return Uint8List.fromList(hash.bytes);
  }

  Future<SecretChatFingerprint> _fingerprint({
    required Uint8List chatId,
    required Uint8List initiatorEphemeral,
    required Uint8List nonce,
    required Uint8List responderEphemeral,
    required Uint8List responderKem,
  }) async {
    final fingerprint = await _sha256.hash([
      ..._labelFingerprint,
      ..._lengthPrefixed(chatId),
      ...initiatorEphemeral,
      ...nonce,
      ...responderEphemeral,
      ...responderKem,
    ]);
    final sas = (await _sha256.hash([..._labelSas, ...fingerprint.bytes])).bytes;
    // 5 эмодзи × 6 бит = 30 бит из первых 4 байт; алфавит — общий со звонками.
    final bits = (sas[0] << 24) | (sas[1] << 16) | (sas[2] << 8) | sas[3];
    final emoji = [for (var index = 0; index < fingerprintEmojiCount; index++) CallKeys._sasAlphabet[(bits >> (26 - index * 6)) & 0x3f]];
    return SecretChatFingerprint(bytes: Uint8List.fromList(fingerprint.bytes), emoji: emoji);
  }

  List<int> _lengthPrefixed(Uint8List bytes) => [...(ByteData(2)..setUint16(0, bytes.length, Endian.big)).buffer.asUint8List(), ...bytes];

  void _requireLength(Uint8List bytes, int length, String name) {
    if (bytes.length != length) throw SecretChatException('handshake: bad $name length ${bytes.length}');
  }
}
