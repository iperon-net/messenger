part of 'crypto.dart';

/// Клиентская сторона (V)OPRF для шифронабора ristretto255-SHA512 в режиме VOPRF
/// (mode 0x01), байт-совместимая с серверной `internal/crypto/voprf.go`
/// (`github.com/bytemare/voprf`).
///
/// Применяется для приватного поиска контактов: сервер вычисляет OPRF над
/// «ослеплёнными» (blinded) номерами телефонов, не узнавая сами номера. Итог
/// [finalize] совпадает с серверным `FullEvaluate` и с тем, что хранится в
/// `user.oprf`, поэтому по нему можно сверять членство.
///
/// DLEQ-пруф из VOPRF-ответа сейчас НЕ проверяется (для матчинга это не нужно
/// при честном сервере); проверка — задача на будущее (hardening).
class Oprf {
  final Logger logger;

  Oprf({required this.logger});

  // contextString = "OPRFV1-" || 0x01 (режим VOPRF) || "-ristretto255-SHA512".
  static final Uint8List _contextString = Uint8List.fromList([...utf8.encode('OPRFV1-'), 0x01, ...utf8.encode('-ristretto255-SHA512')]);

  // DST для hash-to-group: "HashToGroup-" || contextString.
  static final Uint8List _hashToGroupDst = Uint8List.fromList([...utf8.encode('HashToGroup-'), ..._contextString]);

  static final Uint8List _finalizeDst = Uint8List.fromList(utf8.encode('Finalize'));

  final _sha512 = Sha512();

  /// Ослепляет один вход. Возвращает `(blind, blindedElement)` в кодировке байт:
  /// `blind` — 32-байтовый скаляр (нужен для [finalize]), `blindedElement` —
  /// 32-байтовый элемент группы (отправляется серверу).
  ///
  /// [fixedBlind] задаёт скаляр ослепления явно (32 байта, little-endian) —
  /// только для детерминированных тестов; в проде не передавать, чтобы каждый
  /// запрос использовал свежий случайный blind.
  Future<(Uint8List blind, Uint8List blindedElement)> blind(List<int> input, {Uint8List? fixedBlind}) async {
    final p = await _hashToGroup(input);
    final blindScalar = fixedBlind != null ? (Scalar()..decode(fixedBlind)) : _randomScalar();

    final blinded = Element.newElement();
    blinded.scalarMult(blindScalar, p);

    return (Uint8List.fromList(blindScalar.encode()), Uint8List.fromList(blinded.encode()));
  }

  /// Финализирует протокол: по исходному [input], использованному [blind] и
  /// сериализованной серверной `Evaluation` возвращает выход OPRF
  /// (SHA-512, 64 байта) — совпадает с `user.oprf` на сервере.
  Future<Uint8List> finalize({required List<int> input, required Uint8List blind, required Uint8List evaluation}) async {
    final evaluated = _firstEvaluatedElement(evaluation);

    final blindScalar = Scalar()..decode(blind);
    final inverse = Scalar()..invert(blindScalar);

    final unblinded = Element.newElement();
    unblinded.scalarMult(inverse, evaluated);

    return _finalizeHash(input, unblinded.encode());
  }

  /// Отображает вход в элемент группы ristretto255 через
  /// expand_message_xmd(SHA-512, ..., 64) + FromUniformBytes.
  Future<Element> _hashToGroup(List<int> input) async {
    final uniform = await _expandMessageXmd(input, _hashToGroupDst, 64);

    final element = Element.newElement();
    element.fromUniformBytes(Uint8List.fromList(uniform));

    return element;
  }

  /// Разбирает сериализованную `Evaluation`
  /// (`I2OSP(ne,2) || I2OSP(lp,2) || elements... || proofC || proofS`) и
  /// возвращает первый вычисленный элемент. Пруф игнорируется.
  Element _firstEvaluatedElement(Uint8List evaluation) {
    if (evaluation.length < 4) {
      throw Exception('oprf: evaluation too short');
    }

    final ne = (evaluation[0] << 8) | evaluation[1];
    final lp = (evaluation[2] << 8) | evaluation[3];

    if (ne < 1 || lp != 32 || evaluation.length < 4 + ne * lp) {
      throw Exception('oprf: invalid evaluation header');
    }

    final element = Element.newElement();
    element.decode(Uint8List.fromList(evaluation.sublist(4, 4 + lp)));

    return element;
  }

  /// hashTranscript = SHA-512( I2OSP(len(input),2) || input ||
  /// I2OSP(len(N),2) || N || "Finalize" ).
  Future<Uint8List> _finalizeHash(List<int> input, List<int> unblindedEncoded) async {
    final builder = BytesBuilder();
    builder.add(_i2osp2(input.length));
    builder.add(input);
    builder.add(_i2osp2(unblindedEncoded.length));
    builder.add(unblindedEncoded);
    builder.add(_finalizeDst);

    final digest = await _sha512.hash(builder.toBytes());

    return Uint8List.fromList(digest.bytes);
  }

  Scalar _randomScalar() {
    final random = Random.secure();
    final bytes = Uint8List(64);
    for (var i = 0; i < 64; i++) {
      bytes[i] = random.nextInt(256);
    }

    return Scalar()..setUniformBytes(bytes);
  }

  /// RFC 9380 §5.3.1 expand_message_xmd для SHA-512 (b_in_bytes=64, s_in_bytes=128).
  Future<List<int>> _expandMessageXmd(List<int> msg, List<int> dst, int lenInBytes) async {
    const bInBytes = 64;
    const sInBytes = 128;

    final ell = (lenInBytes + bInBytes - 1) ~/ bInBytes;
    if (ell > 255) {
      throw Exception('oprf: expand_message_xmd length too large');
    }

    final dstPrime = <int>[...dst, dst.length];
    final zPad = List<int>.filled(sInBytes, 0);
    final lIbStr = _i2osp2(lenInBytes);

    final msgPrime = <int>[...zPad, ...msg, ...lIbStr, 0, ...dstPrime];
    final b0 = (await _sha512.hash(msgPrime)).bytes;

    final bValues = <List<int>>[];
    bValues.add((await _sha512.hash(<int>[...b0, 1, ...dstPrime])).bytes);

    for (var i = 2; i <= ell; i++) {
      final xored = <int>[for (var j = 0; j < bInBytes; j++) b0[j] ^ bValues[i - 2][j]];
      bValues.add((await _sha512.hash(<int>[...xored, i, ...dstPrime])).bytes);
    }

    final uniform = <int>[];
    for (final value in bValues) {
      uniform.addAll(value);
    }

    return uniform.sublist(0, lenInBytes);
  }

  Uint8List _i2osp2(int value) => Uint8List(2)
    ..[0] = (value >> 8) & 0xff
    ..[1] = value & 0xff;
}
