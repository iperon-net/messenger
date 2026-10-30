part of 'crypto.dart';

/// Клиентская сторона OPAQUE-3DH (RFC 9807) для облачного пароля: сервер не
/// получает ни пароль, ни что-либо ему равноценное — только ослеплённый
/// элемент OPRF, публичные ключи и MAC'и.
///
/// Конфигурация (должна совпадать с серверной, `github.com/bytemare/opaque`):
/// OPRF ristretto255-SHA512 (modeOPRF 0x00, RFC 9497), HKDF-SHA512,
/// HMAC-SHA512, SHA-512, группа AKE ristretto255, KSF и context — параметры
/// [OpaqueClient]. Идентичности по умолчанию — публичные ключи сторон.
///
/// Вся криптография, кроме KSF, синхронная (pure-Dart `DartSha512`/`DartHmac`),
/// чтобы протокол целиком можно было увести в изолят.

/// Ошибка протокола OPAQUE.
class OpaqueException implements Exception {
  final OpaqueError error;
  final String message;

  const OpaqueException(this.error, this.message);

  @override
  String toString() => 'OpaqueException($error): $message';
}

enum OpaqueError {
  /// Конверт не расшифровался — неверный пароль (или запись для этого
  /// пользователя не существует: сервер отвечает поддельной записью).
  wrongPassword,

  /// MAC сервера не сошёлся — ответ не от владельца ключа сервера.
  serverAuthentication,

  /// Сообщение сервера не разбирается (длина, некорректный элемент группы).
  invalidMessage,
}

/// Key Stretching Function (RFC 9807 §2.3): замедляет офлайн-перебор пароля,
/// считается только на клиенте. Должна быть одной и той же на всех
/// устройствах пользователя навсегда — иначе пароль перестанет подходить.
abstract class OpaqueKsf {
  const OpaqueKsf();

  /// Тождественная функция — только для тестовых векторов RFC.
  const factory OpaqueKsf.identity() = _IdentityKsf;

  /// Argon2id с нулевой солью 16 байт и выходом [OpaqueClient._nh] байт, как в
  /// рекомендованной конфигурации RFC 9807 §7. Соль не нужна: вход — выход OPRF,
  /// уже уникальный для пользователя за счёт ключа сервера.
  const factory OpaqueKsf.argon2id({required int iterations, required int memory, required int parallelism}) = _Argon2idKsf;

  Future<Uint8List> stretch(Uint8List msg);
}

class _IdentityKsf extends OpaqueKsf {
  const _IdentityKsf();

  @override
  Future<Uint8List> stretch(Uint8List msg) async => msg;
}

class _Argon2idKsf extends OpaqueKsf {
  final int iterations;
  final int memory; // KiB
  final int parallelism;

  const _Argon2idKsf({required this.iterations, required this.memory, required this.parallelism});

  @override
  Future<Uint8List> stretch(Uint8List msg) async {
    final algorithm = DartArgon2id(parallelism: parallelism, memory: memory, iterations: iterations, hashLength: OpaqueClient._nh);
    final key = await algorithm.deriveKey(secretKey: SecretKey(msg), nonce: Uint8List(16));
    return Uint8List.fromList(await key.extractBytes());
  }
}

/// Состояние между `RegistrationRequest` и `RegistrationResponse`.
class OpaqueRegistrationState {
  final Uint8List _password;
  final Scalar _blind;

  OpaqueRegistrationState._(this._password, this._blind);
}

/// Итог регистрации: [record] уходит на сервер, [exportKey] остаётся на клиенте.
class OpaqueRegistrationResult {
  final Uint8List record;
  final Uint8List exportKey;

  const OpaqueRegistrationResult({required this.record, required this.exportKey});
}

/// Состояние между `KE1` и `KE2`.
class OpaqueLoginState {
  final Uint8List _password;
  final Scalar _blind;
  final Scalar _clientSecret;
  final Uint8List _ke1;

  OpaqueLoginState._(this._password, this._blind, this._clientSecret, this._ke1);
}

/// Итог входа: [ke3] уходит на сервер; [sessionKey] общий с сервером,
/// [exportKey] — только клиентский (совпадает с полученным при регистрации).
class OpaqueLoginResult {
  final Uint8List ke3;
  final Uint8List sessionKey;
  final Uint8List exportKey;

  const OpaqueLoginResult({required this.ke3, required this.sessionKey, required this.exportKey});
}

class OpaqueClient {
  static const _nn = 32; // nonce
  static const _nseed = 32;
  static const _npk = 32; // публичный ключ AKE
  static const _noe = 32; // элемент OPRF
  static const _nh = 64; // SHA-512
  static const _nm = 64; // HMAC-SHA512
  static const _nx = 64; // HKDF-SHA512
  static const _envelopeLength = _nn + _nm;
  static const _maskedResponseLength = _npk + _envelopeLength;
  static const _ke2Length = _noe + _nn + _maskedResponseLength + _nn + _npk + _nm;

  // contextString = "OPRFV1-" || 0x00 (modeOPRF) || "-ristretto255-SHA512".
  static final Uint8List _contextString = Uint8List.fromList([...utf8.encode('OPRFV1-'), 0x00, ...utf8.encode('-ristretto255-SHA512')]);
  static final Uint8List _hashToGroupDst = Uint8List.fromList([...utf8.encode('HashToGroup-'), ..._contextString]);
  static final Uint8List _deriveKeyPairDst = Uint8List.fromList([...utf8.encode('DeriveKeyPair'), ..._contextString]);

  static const _sha512 = DartSha512();
  static final _hmac = DartHmac(const DartSha512());

  /// Общий контекст протокола (RFC 9807 §6.4.2.1) — входит в транскрипт.
  final Uint8List context;
  final OpaqueKsf ksf;

  /// Идентичности; null — публичные ключи сторон.
  final Uint8List? serverIdentity;
  final Uint8List? clientIdentity;

  OpaqueClient({required this.context, required this.ksf, this.serverIdentity, this.clientIdentity});

  // ── Регистрация (§5) ──────────────────────────────────────────────────────

  /// `CreateRegistrationRequest`: возвращает `RegistrationRequest` и состояние.
  (Uint8List request, OpaqueRegistrationState state) registrationStart(List<int> password, {@visibleForTesting Uint8List? blind}) {
    final pw = Uint8List.fromList(password);
    final (blindScalar, blinded) = _blind(pw, blind);
    return (blinded, OpaqueRegistrationState._(pw, blindScalar));
  }

  /// `FinalizeRegistrationRequest`: по `RegistrationResponse` строит запись
  /// для сервера (`client_public_key || masking_key || envelope`).
  Future<OpaqueRegistrationResult> registrationFinish(
    OpaqueRegistrationState state,
    List<int> response, {
    @visibleForTesting Uint8List? envelopeNonce,
  }) async {
    if (response.length != _noe + _npk) {
      throw const OpaqueException(OpaqueError.invalidMessage, 'registration response length');
    }
    final evaluated = _decodeElement(response.sublist(0, _noe));
    final serverPublicKey = Uint8List.fromList(response.sublist(_noe));
    _decodeElement(serverPublicKey);

    final randomizedPassword = await _randomizedPassword(state._password, state._blind, evaluated);

    final nonce = envelopeNonce ?? _random(_nn);
    final maskingKey = _expand(randomizedPassword, utf8.encode('MaskingKey'), _nh);
    final authKey = _expand(randomizedPassword, [...nonce, ...utf8.encode('AuthKey')], _nh);
    final exportKey = _expand(randomizedPassword, [...nonce, ...utf8.encode('ExportKey')], _nh);
    final seed = _expand(randomizedPassword, [...nonce, ...utf8.encode('PrivateKey')], _nseed);
    final (_, clientPublicKey) = _deriveDiffieHellmanKeyPair(seed);

    final authTag = _mac(authKey, [...nonce, ..._cleartextCredentials(serverPublicKey, clientPublicKey)]);

    final record = BytesBuilder(copy: false)
      ..add(clientPublicKey)
      ..add(maskingKey)
      ..add(nonce)
      ..add(authTag);
    return OpaqueRegistrationResult(record: record.toBytes(), exportKey: exportKey);
  }

  // ── Вход (§6) ─────────────────────────────────────────────────────────────

  /// `GenerateKE1`: `blinded_message || client_nonce || client_public_keyshare`.
  (Uint8List ke1, OpaqueLoginState state) loginStart(
    List<int> password, {
    @visibleForTesting Uint8List? blind,
    @visibleForTesting Uint8List? clientNonce,
    @visibleForTesting Uint8List? clientKeyshareSeed,
  }) {
    final pw = Uint8List.fromList(password);
    final (blindScalar, blinded) = _blind(pw, blind);
    final nonce = clientNonce ?? _random(_nn);
    final (clientSecret, clientPublicKeyshare) = _deriveDiffieHellmanKeyPair(clientKeyshareSeed ?? _random(_nseed));

    final ke1 = BytesBuilder(copy: false)
      ..add(blinded)
      ..add(nonce)
      ..add(clientPublicKeyshare);
    final bytes = ke1.toBytes();
    return (bytes, OpaqueLoginState._(pw, blindScalar, clientSecret, bytes));
  }

  /// `GenerateKE3`: восстанавливает ключ клиента из `KE2`, проверяет MAC
  /// сервера и возвращает `KE3`. Неверный пароль — [OpaqueError.wrongPassword].
  Future<OpaqueLoginResult> loginFinish(OpaqueLoginState state, List<int> ke2) async {
    if (ke2.length != _ke2Length) {
      throw const OpaqueException(OpaqueError.invalidMessage, 'KE2 length');
    }
    var offset = 0;
    Uint8List take(int n) => Uint8List.fromList(ke2.sublist(offset, offset += n));

    final evaluatedMessage = take(_noe);
    final maskingNonce = take(_nn);
    final maskedResponse = take(_maskedResponseLength);
    final serverNonce = take(_nn);
    final serverPublicKeyshare = take(_npk);
    final serverMac = take(_nm);

    // RecoverCredentials (§6.3.2.3).
    final evaluated = _decodeElement(evaluatedMessage);
    final randomizedPassword = await _randomizedPassword(state._password, state._blind, evaluated);
    final maskingKey = _expand(randomizedPassword, utf8.encode('MaskingKey'), _nh);
    final pad = _expand(maskingKey, [...maskingNonce, ...utf8.encode('CredentialResponsePad')], _maskedResponseLength);
    final unmasked = Uint8List(_maskedResponseLength);
    for (var i = 0; i < unmasked.length; i++) {
      unmasked[i] = pad[i] ^ maskedResponse[i];
    }
    final serverPublicKey = unmasked.sublist(0, _npk);
    final envelopeNonce = unmasked.sublist(_npk, _npk + _nn);
    final authTag = unmasked.sublist(_npk + _nn);

    // Recover (§4.1.3). Неверный пароль даёт мусор вместо ключа сервера —
    // это тоже wrongPassword, а не invalidMessage.
    final authKey = _expand(randomizedPassword, [...envelopeNonce, ...utf8.encode('AuthKey')], _nh);
    final exportKey = _expand(randomizedPassword, [...envelopeNonce, ...utf8.encode('ExportKey')], _nh);
    final seed = _expand(randomizedPassword, [...envelopeNonce, ...utf8.encode('PrivateKey')], _nseed);
    final (clientPrivateKey, clientPublicKey) = _deriveDiffieHellmanKeyPair(seed);
    final cleartext = _cleartextCredentials(serverPublicKey, clientPublicKey);
    if (!_constantTimeEquals(authTag, _mac(authKey, [...envelopeNonce, ...cleartext]))) {
      throw const OpaqueException(OpaqueError.wrongPassword, 'envelope recovery failed');
    }
    final serverPublicKeyElement = _decodeElement(serverPublicKey);

    // AuthClientFinalize (§6.4.3).
    final serverKeyshareElement = _decodeElement(serverPublicKeyshare);
    final ikm = BytesBuilder(copy: false)
      ..add(_dh(state._clientSecret, serverKeyshareElement))
      ..add(_dh(state._clientSecret, serverPublicKeyElement))
      ..add(_dh(clientPrivateKey, serverKeyshareElement));

    final preamble = _preamble(
      clientIdentity: clientIdentity ?? clientPublicKey,
      ke1: state._ke1,
      serverIdentity: serverIdentity ?? serverPublicKey,
      credentialResponse: [...evaluatedMessage, ...maskingNonce, ...maskedResponse],
      serverNonce: serverNonce,
      serverPublicKeyshare: serverPublicKeyshare,
    );
    final (km2, km3, sessionKey) = _deriveKeys(ikm.toBytes(), preamble);

    final expectedServerMac = _mac(km2, _hash(preamble));
    if (!_constantTimeEquals(serverMac, expectedServerMac)) {
      throw const OpaqueException(OpaqueError.serverAuthentication, 'server MAC mismatch');
    }
    final clientMac = _mac(km3, _hash([...preamble, ...expectedServerMac]));

    return OpaqueLoginResult(ke3: clientMac, sessionKey: sessionKey, exportKey: exportKey);
  }

  // ── OPRF (RFC 9497, modeOPRF) ─────────────────────────────────────────────

  (Scalar, Uint8List) _blind(Uint8List password, Uint8List? fixedBlind) {
    final input = _hashToGroup(password);
    if (_isIdentity(input)) {
      throw const OpaqueException(OpaqueError.invalidMessage, 'password maps to identity');
    }
    final blind = fixedBlind != null ? (Scalar()..setCanonicalBytes(fixedBlind)) : _randomScalar();
    final blinded = Element.newElement()..scalarMult(blind, input);
    return (blind, Uint8List.fromList(blinded.encode()));
  }

  /// `Extract("", oprf_output || Stretch(oprf_output))`.
  Future<Uint8List> _randomizedPassword(Uint8List password, Scalar blind, Element evaluated) async {
    final unblinded = Element.newElement()..scalarMult(Scalar()..invert(blind), evaluated);
    final encoded = unblinded.encode();
    final oprfOutput = _hash([
      ..._i2osp2(password.length),
      ...password,
      ..._i2osp2(encoded.length),
      ...encoded,
      ...utf8.encode('Finalize'),
    ]);
    final stretched = await ksf.stretch(oprfOutput);
    return _extract(const [], [...oprfOutput, ...stretched]);
  }

  Element _hashToGroup(List<int> input) {
    final element = Element.newElement();
    element.setUniformBytes(_expandMessageXmd(input, _hashToGroupDst, 64));
    return element;
  }

  /// `DeriveKeyPair(seed, "OPAQUE-DeriveDiffieHellmanKeyPair")` (RFC 9497 §3.2).
  (Scalar, Uint8List) _deriveDiffieHellmanKeyPair(List<int> seed) {
    final info = utf8.encode('OPAQUE-DeriveDiffieHellmanKeyPair');
    final deriveInput = [...seed, ..._i2osp2(info.length), ...info];
    final zero = Scalar();
    for (var counter = 0; counter <= 255; counter++) {
      final sk = Scalar()..setUniformBytes(_expandMessageXmd([...deriveInput, counter], _deriveKeyPairDst, 64));
      if (sk.equal(zero) == 0) {
        final pk = Element.newElement()..scalarBaseMult(sk);
        return (sk, Uint8List.fromList(pk.encode()));
      }
    }
    throw const OpaqueException(OpaqueError.invalidMessage, 'DeriveKeyPair failed');
  }

  // ── 3DH (§6.4) ────────────────────────────────────────────────────────────

  Uint8List _dh(Scalar k, Element b) => Uint8List.fromList((Element.newElement()..scalarMult(k, b)).encode());

  /// `server_public_key || len‖server_identity || len‖client_identity`.
  Uint8List _cleartextCredentials(Uint8List serverPublicKey, Uint8List clientPublicKey) {
    final sid = serverIdentity ?? serverPublicKey;
    final cid = clientIdentity ?? clientPublicKey;
    return Uint8List.fromList([...serverPublicKey, ..._i2osp2(sid.length), ...sid, ..._i2osp2(cid.length), ...cid]);
  }

  Uint8List _preamble({
    required List<int> clientIdentity,
    required List<int> ke1,
    required List<int> serverIdentity,
    required List<int> credentialResponse,
    required List<int> serverNonce,
    required List<int> serverPublicKeyshare,
  }) {
    final b = BytesBuilder(copy: false)
      ..add(utf8.encode('OPAQUEv1-'))
      ..add(_i2osp2(context.length))
      ..add(context)
      ..add(_i2osp2(clientIdentity.length))
      ..add(clientIdentity)
      ..add(ke1)
      ..add(_i2osp2(serverIdentity.length))
      ..add(serverIdentity)
      ..add(credentialResponse)
      ..add(serverNonce)
      ..add(serverPublicKeyshare);
    return b.toBytes();
  }

  (Uint8List km2, Uint8List km3, Uint8List sessionKey) _deriveKeys(Uint8List ikm, Uint8List preamble) {
    final prk = _extract(const [], ikm);
    final transcript = _hash(preamble);
    final handshakeSecret = _deriveSecret(prk, 'HandshakeSecret', transcript);
    final sessionKey = _deriveSecret(prk, 'SessionKey', transcript);
    final km2 = _deriveSecret(handshakeSecret, 'ServerMAC', const []);
    final km3 = _deriveSecret(handshakeSecret, 'ClientMAC', const []);
    return (km2, km3, sessionKey);
  }

  /// `Derive-Secret` = `Expand-Label(secret, label, context, Nx)` (TLS 1.3 вид).
  Uint8List _deriveSecret(Uint8List secret, String label, List<int> context) {
    final fullLabel = utf8.encode('OPAQUE-$label');
    final info = [..._i2osp2(_nx), fullLabel.length, ...fullLabel, context.length, ...context];
    return _expand(secret, info, _nx);
  }

  // ── Примитивы ─────────────────────────────────────────────────────────────

  Element _decodeElement(List<int> bytes) {
    final element = Element.newElement();
    try {
      element.setCanonicalBytes(Uint8List.fromList(bytes));
    } catch (_) {
      throw const OpaqueException(OpaqueError.invalidMessage, 'invalid group element');
    }
    if (_isIdentity(element)) {
      throw const OpaqueException(OpaqueError.invalidMessage, 'identity element');
    }
    return element;
  }

  bool _isIdentity(Element e) => e.equal(Element.newIdentityElement()) == 1;

  Uint8List _hash(List<int> data) => Uint8List.fromList(_sha512.hashSync(data).bytes);

  Uint8List _mac(List<int> key, List<int> data) =>
      Uint8List.fromList(_hmac.calculateMacSync(data, secretKeyData: SecretKeyData(key), nonce: const []).bytes);

  /// HKDF-Extract; пустая соль = `Nh` нулей (для HMAC это одно и то же).
  Uint8List _extract(List<int> salt, List<int> ikm) => _mac(salt.isEmpty ? Uint8List(_nh) : salt, ikm);

  /// HKDF-Expand (RFC 5869).
  Uint8List _expand(List<int> prk, List<int> info, int length) {
    final out = BytesBuilder(copy: false);
    var t = const <int>[];
    for (var i = 1; out.length < length; i++) {
      t = _mac(prk, [...t, ...info, i]);
      out.add(t);
    }
    return Uint8List.sublistView(out.toBytes(), 0, length);
  }

  /// RFC 9380 §5.3.1 expand_message_xmd для SHA-512 (как в [Oprf], но синхронно).
  Uint8List _expandMessageXmd(List<int> msg, List<int> dst, int lenInBytes) {
    const bInBytes = 64;
    const sInBytes = 128;
    final ell = (lenInBytes + bInBytes - 1) ~/ bInBytes;
    final dstPrime = [...dst, dst.length];

    final b0 = _hash([...Uint8List(sInBytes), ...msg, ..._i2osp2(lenInBytes), 0, ...dstPrime]);
    final out = BytesBuilder(copy: false);
    var bi = _hash([...b0, 1, ...dstPrime]);
    out.add(bi);
    for (var i = 2; i <= ell; i++) {
      bi = _hash([for (var j = 0; j < bInBytes; j++) b0[j] ^ bi[j], i, ...dstPrime]);
      out.add(bi);
    }
    return Uint8List.sublistView(out.toBytes(), 0, lenInBytes);
  }

  Scalar _randomScalar() {
    final zero = Scalar();
    while (true) {
      final s = Scalar()..setUniformBytes(_random(64));
      if (s.equal(zero) == 0) return s;
    }
  }

  Uint8List _random(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static Uint8List _i2osp2(int value) => Uint8List(2)
    ..[0] = (value >> 8) & 0xff
    ..[1] = value & 0xff;
}
