part of 'crypto.dart';

// Клиентская реализация VOPRF (RFC 9497) в режиме VOPRF (с доказательством),
// ciphersuite ristretto255-SHA512. Полностью совместима с серверной частью на
// github.com/bytemare/voprf (Ristretto255Sha512, режим voprf.VOPRF):
//   /Users/kostya/GolandProjects/iperon/internal/crypto/voprf.go
//
// Протокол позволяет серверу вычислить PRF(k, input), не узнавая сам input,
// при этом клиент криптографически проверяет, что сервер использовал ключ k,
// соответствующий известному публичному ключу сервера.
//
// Порядок выполнения:
//   final voprf   = VOPRF(serverPublicKey: pk);
//   final session = voprf.blind(input);            // отправляем session.blindedElement
//   final output  = session.finalize(evaluation);  // evaluation получаем от сервера
//
// В Dart нет готовой группы Ristretto255, поэтому она реализована здесь с нуля:
//  - поле GF(2^255-19) на BigInt;
//  - арифметика расширенных скрученных координат Эдвардса (a=-1);
//  - ristretto255 encode/decode и отображение Elligator (FromUniformBytes);
//  - скаляры по модулю порядка группы l;
//  - expand_message_xmd на SHA-512 (RFC 9380).

/// Ошибка выполнения протокола VOPRF.
class VOPRFException implements Exception {
  final String message;

  VOPRFException(this.message);

  @override
  String toString() => 'VOPRFException: $message';
}

/// Клиент VOPRF, инициализированный публичным ключом сервера (32 байта,
/// каноническое ristretto255-кодирование).
class VOPRF {
  /// Идентификатор ciphersuite, как в RFC 9497.
  static const String suite = 'ristretto255-SHA512';

  /// Режим VOPRF (verifiable) — байт 0x01 в contextString.
  static const int _modeVoprf = 0x01;

  _RistrettoPoint? _serverPublicKey;

  VOPRF();

  /// Задаёт публичный ключ сервера (32 байта, каноническое ristretto255-кодирование),
  /// по которому при финализации проверяется доказательство.
  void setServerPublicKey(List<int> serverPublicKey) {
    final pk = _RistrettoPoint.decode(serverPublicKey);
    if (pk == null) {
      throw VOPRFException('invalid server public key');
    }
    _serverPublicKey = pk;
  }

  /// contextString = "OPRFV1-" || I2OSP(mode, 1) || "-" || identifier.
  static final List<int> _contextString = <int>[
    ...ascii.encode('OPRFV1-'),
    _modeVoprf,
    ...ascii.encode('-'),
    ...ascii.encode(suite),
  ];

  static final List<int> _dstHashToGroup =
      <int>[...ascii.encode('HashToGroup-'), ..._contextString];
  static final List<int> _dstHashToScalar =
      <int>[...ascii.encode('HashToScalar-'), ..._contextString];
  static final List<int> _dstSeed =
      <int>[...ascii.encode('Seed-'), ..._contextString];

  /// Затемняет вход случайным фактором и возвращает сессию вместе с
  /// сериализованным затемнённым элементом (`session.blindedElement`) для
  /// отправки серверу.
  VOPRFSession blind(List<int> input) {
    final serverPublicKey = _serverPublicKey;
    if (serverPublicKey == null) {
      throw VOPRFException('server public key is not set');
    }

    final blind = _Scalar.random();

    final p = _hashToGroup(input);
    if (p.isIdentity) {
      // Вход детерминированно отобразился в нейтральный элемент — как и в Go,
      // считаем это ошибкой ввода.
      throw VOPRFException(
          'invalid input - maps to the group identity element');
    }

    final blindedElement = p.multiply(blind);

    return VOPRFSession._(
      serverPublicKey: serverPublicKey,
      input: List<int>.unmodifiable(input),
      blind: blind,
      blindedElement: blindedElement,
    );
  }

  static _RistrettoPoint _hashToGroup(List<int> input) {
    final uniform = _expandMessageXmd(input, _dstHashToGroup, 64);
    return _RistrettoPoint.fromUniformBytes(uniform);
  }

  static _Scalar _hashToScalar(List<int> input) {
    final uniform = _expandMessageXmd(input, _dstHashToScalar, 64);
    return _Scalar.fromUniformBytes(uniform);
  }
}

/// Состояние клиента между [VOPRF.blind] и [VOPRFSession.finalize].
class VOPRFSession {
  final _RistrettoPoint _serverPublicKey;
  final List<int> _input;
  final _Scalar _blind;
  final _RistrettoPoint _blindedElementPoint;

  /// Сериализованный затемнённый элемент (32 байта) для отправки серверу.
  final List<int> blindedElement;

  VOPRFSession._({
    required _RistrettoPoint serverPublicKey,
    required List<int> input,
    required _Scalar blind,
    required _RistrettoPoint blindedElement,
  })  : _serverPublicKey = serverPublicKey,
        _input = input,
        _blind = blind,
        _blindedElementPoint = blindedElement,
        blindedElement = blindedElement.encode();

  /// Проверяет доказательство сервера, снимает затемнение с оценки и возвращает
  /// итоговое значение PRF (64 байта). [evaluation] — это
  /// `Evaluation.Serialize()` с сервера.
  ///
  /// Бросает [VOPRFException], если доказательство неверно (сервер использовал
  /// не тот ключ) или данные повреждены.
  List<int> finalize(List<int> evaluation) {
    final eval = _Evaluation.parse(evaluation);

    if (eval.elements.length != 1) {
      throw VOPRFException('invalid number of elements in evaluation');
    }

    final evaluated = _RistrettoPoint.decode(eval.elements[0]);
    if (evaluated == null) {
      throw VOPRFException('could not decode evaluated element');
    }

    final proofC = _Scalar.decode(eval.proofC);
    final proofS = _Scalar.decode(eval.proofS);
    if (proofC == null || proofS == null) {
      throw VOPRFException('invalid proof scalar');
    }

    if (!_verifyProof(
      pk: _serverPublicKey,
      cs: [_blindedElementPoint],
      ds: [evaluated],
      proofC: proofC,
      proofS: proofS,
    )) {
      throw VOPRFException('proof fails');
    }

    // unblind: N = blind^{-1} * evaluated.
    final unblinded = evaluated.multiply(_blind.invert());

    return _hashTranscript(_input, unblinded.encode());
  }

  // hashTranscript для режимов OPRF/VOPRF (info == nil):
  //   SHA-512( LengthPrefix(input) || LengthPrefix(unblinded) || "Finalize" )
  static List<int> _hashTranscript(List<int> input, List<int> unblinded) {
    final b = BytesBuilder();
    b.add(_lengthPrefix(input));
    b.add(_lengthPrefix(unblinded));
    b.add(ascii.encode('Finalize'));
    return _sha512(b.toBytes());
  }

  bool _verifyProof({
    required _RistrettoPoint pk,
    required List<_RistrettoPoint> cs,
    required List<_RistrettoPoint> ds,
    required _Scalar proofC,
    required _Scalar proofS,
  }) {
    final encGk = _lengthPrefix(pk.encode());
    final composites = _computeComposites(encGk, cs, ds);
    final a0 = composites.$1;
    final a1 = composites.$2;

    // a2 = Base*proofS + pk*proofC
    final ap = pk.multiply(proofC);
    final a2 = _RistrettoPoint.base().multiply(proofS).add(ap);

    // a3 = a0*proofS + a1*proofC
    final a3 = a0.multiply(proofS).add(a1.multiply(proofC));

    final expectedC = _challenge(encGk, a0, a1, a2, a3);

    return _ctEqual(expectedC.encode(), proofC.encode());
  }

  // computeComposites (клиентская версия): возвращает (M, Z).
  (_RistrettoPoint, _RistrettoPoint) _computeComposites(
    List<int> encGk,
    List<_RistrettoPoint> cs,
    List<_RistrettoPoint> ds,
  ) {
    final encSeedDst = _lengthPrefix(VOPRF._dstSeed);
    final seed = _sha512(<int>[...encGk, ...encSeedDst]);
    final encSeed = _lengthPrefix(seed);

    var m = _RistrettoPoint.identity();
    var z = _RistrettoPoint.identity();

    for (var i = 0; i < cs.length; i++) {
      final di = _ccScalar(encSeed, i, cs[i], ds[i]);
      m = cs[i].multiply(di).add(m);
      z = ds[i].multiply(di).add(z);
    }

    return (m, z);
  }

  _Scalar _ccScalar(
    List<int> encSeed,
    int index,
    _RistrettoPoint ci,
    _RistrettoPoint di,
  ) {
    final input = <int>[
      ...encSeed,
      ..._i2osp2(index),
      ..._lengthPrefix(ci.encode()),
      ..._lengthPrefix(di.encode()),
      ...ascii.encode('Composite'),
    ];
    return VOPRF._hashToScalar(input);
  }

  _Scalar _challenge(
    List<int> encPks,
    _RistrettoPoint a0,
    _RistrettoPoint a1,
    _RistrettoPoint a2,
    _RistrettoPoint a3,
  ) {
    final input = <int>[
      ...encPks,
      ..._lengthPrefix(a0.encode()),
      ..._lengthPrefix(a1.encode()),
      ..._lengthPrefix(a2.encode()),
      ..._lengthPrefix(a3.encode()),
      ...ascii.encode('Challenge'),
    ];
    return VOPRF._hashToScalar(input);
  }
}

// ===========================================================================
//  Разбор Evaluation (формат bytemare/voprf Evaluation.Serialize):
//    I2OSP(ne, 2) || I2OSP(lp, 2) || elements[0..ne] || proofC || proofS
// ===========================================================================
class _Evaluation {
  final List<List<int>> elements;
  final List<int> proofC;
  final List<int> proofS;

  _Evaluation(this.elements, this.proofC, this.proofS);

  static _Evaluation parse(List<int> input) {
    if (input.length < 4) {
      throw VOPRFException('evaluation: insufficient header length');
    }

    final ne = (input[0] << 8) | input[1];
    final lp = (input[2] << 8) | input[3];

    if (input.length < 4 + ne * lp) {
      throw VOPRFException('evaluation: insufficient number of evaluations');
    }

    final elements = <List<int>>[];
    var offset = 4;
    for (var i = 0; i < ne; i++) {
      elements.add(input.sublist(offset, offset + lp));
      offset += lp;
    }

    if (offset >= input.length) {
      throw VOPRFException('evaluation: missing proof');
    }

    final proof = input.sublist(offset);
    if (proof.length.isOdd) {
      throw VOPRFException('evaluation: invalid length of proof');
    }

    final half = proof.length ~/ 2;
    return _Evaluation(
      elements,
      proof.sublist(0, half),
      proof.sublist(half),
    );
  }
}

// ===========================================================================
//  Вспомогательные функции протокола.
// ===========================================================================

List<int> _sha512(List<int> data) => const DartSha512().hashSync(data).bytes;

/// I2OSP(value, 2) — big-endian.
List<int> _i2osp2(int value) => <int>[(value >> 8) & 0xff, value & 0xff];

/// LengthPrefixEncode: I2OSP(len, 2) || input.
List<int> _lengthPrefix(List<int> input) =>
    <int>[..._i2osp2(input.length), ...input];

bool _ctEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

/// expand_message_xmd (RFC 9380, раздел 5.3.1) на SHA-512.
List<int> _expandMessageXmd(List<int> msg, List<int> dst, int length) {
  const bInBytes = 64; // размер выхода SHA-512
  const sInBytes = 128; // размер блока SHA-512

  final ell = (length + bInBytes - 1) ~/ bInBytes;
  if (ell > 255 || length > 65535 || dst.length > 255) {
    throw VOPRFException('expand_message_xmd: invalid length');
  }

  final dstPrime = <int>[...dst, dst.length];
  final zPad = List<int>.filled(sInBytes, 0);
  final lib = _i2osp2(length);

  // b_0 = H(Z_pad || msg || l_i_b || I2OSP(0,1) || dst_prime)
  final b0 = _sha512(<int>[...zPad, ...msg, ...lib, 0, ...dstPrime]);

  // b_1 = H(b_0 || I2OSP(1,1) || dst_prime)
  final b1 = _sha512(<int>[...b0, 1, ...dstPrime]);

  final out = <int>[...b1];
  var prev = b1;
  for (var i = 2; i <= ell; i++) {
    final xored = List<int>.generate(bInBytes, (j) => b0[j] ^ prev[j]);
    final bi = _sha512(<int>[...xored, i, ...dstPrime]);
    out.addAll(bi);
    prev = bi;
  }

  return out.sublist(0, length);
}

// ===========================================================================
//  Поле GF(2^255 - 19).
// ===========================================================================

final BigInt _fieldP = (BigInt.one << 255) - BigInt.from(19);
final BigInt _fieldPow22523Exp = (_fieldP - BigInt.from(5)) ~/ BigInt.from(8);
final BigInt _bit255Mask = (BigInt.one << 255) - BigInt.one;

class _Fe {
  final BigInt v; // нормализовано в [0, p)

  const _Fe._(this.v);

  factory _Fe(BigInt x) => _Fe._(x % _fieldP);

  static final _Fe zero = _Fe._(BigInt.zero);
  static final _Fe one = _Fe._(BigInt.one);
  static final _Fe two = _Fe._(BigInt.two);

  _Fe add(_Fe o) => _Fe._((v + o.v) % _fieldP);
  _Fe sub(_Fe o) => _Fe._((v - o.v) % _fieldP);
  _Fe mul(_Fe o) => _Fe._((v * o.v) % _fieldP);
  _Fe square() => _Fe._((v * v) % _fieldP);
  _Fe neg() => _Fe._((_fieldP - v) % _fieldP);
  _Fe pow(BigInt e) => _Fe._(v.modPow(e, _fieldP));

  bool eq(_Fe o) => v == o.v;
  bool get isZero => v == BigInt.zero;

  // IS_NEGATIVE = младший бит канонического кодирования.
  bool get isNegative => v.isOdd;

  _Fe abs() => isNegative ? neg() : this;

  /// Загружает 32 байта little-endian, очищая старший бит (как radix51.FromBytes).
  static _Fe fromBytes(List<int> b) {
    final n = _leToBig(b) & _bit255Mask;
    return _Fe(n);
  }

  /// Каноническое 32-байтное little-endian кодирование.
  List<int> bytes() => _bigToLe(v, 32);
}

// Константы ristretto255 (draft-irtf-cfrg-ristretto255-decaf448 / gtank).
final _Fe _sqrtM1 = _Fe(BigInt.parse(
    '19681161376707505956807079304988542015446066515923890162744021073123829784752'));
final _Fe _sqrtADMinusOne = _Fe(BigInt.parse(
    '25063068953384623474111414158702152701244531502492656460079210482610430750235'));
final _Fe _invSqrtAMinusD = _Fe(BigInt.parse(
    '54469307008909316920995813868745141605393597292927456921205312896311721017578'));
final _Fe _oneMinusDSq = _Fe(BigInt.parse(
    '1159843021668779879193775521855586647937357759715417654439879720876111806838'));
final _Fe _dMinusOneSq = _Fe(BigInt.parse(
    '40440834346308536858101042469323190826248399146238708352240133220865137265952'));

// d = -121665/121666 кривой curve25519 и удвоенное значение для сложения.
final _Fe _edwardsD = _Fe(BigInt.parse(
    '37095705934669439343138083508754565189542113879843219016388785533085940283555'));
final _Fe _edwardsD2 = _edwardsD.add(_edwardsD);

// Каноническая образующая Эдвардса.
final _Fe _baseX = _Fe(BigInt.parse(
    '15112221349535400772501151409588531511454012693041857206046113283949847762202'));
final _Fe _baseY = _Fe(BigInt.parse(
    '46316835694926478169428394003475163141307993866256225615783033603165251855960'));

/// SQRT_RATIO_M1(u, v): возвращает (was_square, r), где r — неотрицательный
/// корень, согласно ristretto255.
(bool, _Fe) _sqrtRatio(_Fe u, _Fe v) {
  final v3 = v.square().mul(v);
  final v7 = v3.square().mul(v);

  var r = u.mul(v3).mul(u.mul(v7).pow(_fieldPow22523Exp));
  final check = v.mul(r.square());

  final uNeg = u.neg();
  final correctSignSqrt = check.eq(u);
  final flippedSignSqrt = check.eq(uNeg);
  final flippedSignSqrtI = check.eq(uNeg.mul(_sqrtM1));

  if (flippedSignSqrt || flippedSignSqrtI) {
    r = r.mul(_sqrtM1);
  }
  r = r.abs();

  return (correctSignSqrt || flippedSignSqrt, r);
}

// ===========================================================================
//  Точка ristretto255 в расширенных скрученных координатах Эдвардса (a=-1).
// ===========================================================================

class _RistrettoPoint {
  final _Fe x;
  final _Fe y;
  final _Fe z;
  final _Fe t;

  const _RistrettoPoint(this.x, this.y, this.z, this.t);

  static _RistrettoPoint identity() =>
      _RistrettoPoint(_Fe.zero, _Fe.one, _Fe.one, _Fe.zero);

  static _RistrettoPoint base() =>
      _RistrettoPoint(_baseX, _baseY, _Fe.one, _baseX.mul(_baseY));

  bool get isIdentity => eq(identity());

  // Сложение в расширенных координатах (add-2008-hwcd-3, a=-1).
  // Закон Эдвардса полон для curve25519 (d — невычет), поэтому формула
  // корректна и для удвоения, и для нейтрального элемента.
  _RistrettoPoint add(_RistrettoPoint q) {
    final a = y.sub(x).mul(q.y.sub(q.x));
    final b = y.add(x).mul(q.y.add(q.x));
    final c = t.mul(_edwardsD2).mul(q.t);
    final d = z.mul(q.z).mul(_Fe.two);
    final e = b.sub(a);
    final f = d.sub(c);
    final g = d.add(c);
    final h = b.add(a);
    return _RistrettoPoint(e.mul(f), g.mul(h), f.mul(g), e.mul(h));
  }

  _RistrettoPoint negate() => _RistrettoPoint(x.neg(), y, z, t.neg());

  /// Скалярное умножение методом double-and-add.
  _RistrettoPoint multiply(_Scalar s) {
    final k = s.v;
    var r = identity();
    for (var i = k.bitLength - 1; i >= 0; i--) {
      r = r.add(r);
      if ((k >> i).isOdd) {
        r = r.add(this);
      }
    }
    return r;
  }

  // Равенство ristretto255: x1*y2 == y1*x2 ИЛИ y1*y2 == x1*x2.
  bool eq(_RistrettoPoint q) {
    final a = x.mul(q.y).eq(y.mul(q.x));
    final b = y.mul(q.y).eq(x.mul(q.x));
    return a || b;
  }

  /// Каноническое 32-байтное кодирование ristretto255.
  List<int> encode() {
    final u1 = z.add(y).mul(z.sub(y));
    final u2 = x.mul(y);

    final invSqrt = _sqrtRatio(_Fe.one, u1.mul(u2.square())).$2;

    final den1 = invSqrt.mul(u1);
    final den2 = invSqrt.mul(u2);
    final zInv = den1.mul(den2).mul(t);

    final ix0 = x.mul(_sqrtM1);
    final iy0 = y.mul(_sqrtM1);
    final enchantedDenominator = den1.mul(_invSqrtAMinusD);

    final rotate = t.mul(zInv).isNegative;

    var px = rotate ? iy0 : x;
    var py = rotate ? ix0 : y;
    final denInv = rotate ? enchantedDenominator : den2;

    if (px.mul(zInv).isNegative) {
      py = py.neg();
    }

    final s = denInv.mul(z.sub(py)).abs();
    return s.bytes();
  }

  /// Декодирует каноническое 32-байтное ristretto255-кодирование.
  /// Возвращает null при невалидном кодировании.
  static _RistrettoPoint? decode(List<int> input) {
    if (input.length != 32) return null;

    final sInt = _leToBig(input);
    // Каноничность: значение должно быть < p (radix51.FromBytes + проверка Bytes).
    if (sInt >= _fieldP) return null;

    final s = _Fe(sInt);
    if (s.isNegative) return null;

    final ss = s.square();
    final u1 = _Fe.one.sub(ss);
    final u2 = _Fe.one.add(ss);
    final u2Sqr = u2.square();

    // v = -(D * u1^2) - u2_sqr
    final v = u1.square().mul(_edwardsD).neg().sub(u2Sqr);

    final ratio = _sqrtRatio(_Fe.one, v.mul(u2Sqr));
    final wasSquare = ratio.$1;
    final invSqrt = ratio.$2;

    final denX = invSqrt.mul(u2);
    final denY = invSqrt.mul(denX).mul(v);

    final x = _Fe.two.mul(s).mul(denX).abs();
    final y = u1.mul(denY);
    final t = x.mul(y);

    if (!wasSquare || t.isNegative || y.isZero) {
      return null;
    }

    return _RistrettoPoint(x, y, _Fe.one, t);
  }

  /// Отображает 64 равномерных байта в элемент группы (hash-to-group).
  static _RistrettoPoint fromUniformBytes(List<int> b) {
    final p1 = _mapToPoint(_Fe.fromBytes(b.sublist(0, 32)));
    final p2 = _mapToPoint(_Fe.fromBytes(b.sublist(32, 64)));
    return p1.add(p2);
  }

  // MAP (Elligator) из draft ristretto255.
  static _RistrettoPoint _mapToPoint(_Fe tt) {
    final r = _sqrtM1.mul(tt.square());
    final u = r.add(_Fe.one).mul(_oneMinusDSq);

    var c = _Fe.one.neg();
    final v = c.sub(r.mul(_edwardsD)).mul(r.add(_edwardsD));

    final sr = _sqrtRatio(u, v);
    final wasSquare = sr.$1;
    var s = sr.$2;

    final sPrime = s.mul(tt).abs().neg();

    if (!wasSquare) {
      s = sPrime;
      c = r;
    }

    final n = c.mul(r.sub(_Fe.one)).mul(_dMinusOneSq).sub(v);
    final s2 = s.square();

    final w0 = s.mul(v).add(s.mul(v)); // 2 * s * v
    final w1 = n.mul(_sqrtADMinusOne);
    final w2 = _Fe.one.sub(s2);
    final w3 = _Fe.one.add(s2);

    return _RistrettoPoint(
      w0.mul(w3),
      w2.mul(w1),
      w1.mul(w3),
      w0.mul(w2),
    );
  }
}

// ===========================================================================
//  Скаляр по модулю порядка группы l.
// ===========================================================================

final BigInt _scalarL = BigInt.parse(
    '7237005577332262213973186563042994240857116359379907606001950938285454250989');
final BigInt _scalarLMinus2 = _scalarL - BigInt.two;

class _Scalar {
  final BigInt v; // нормализовано в [0, l)

  const _Scalar._(this.v);

  factory _Scalar(BigInt x) => _Scalar._(x % _scalarL);

  _Scalar invert() => _Scalar._(v.modPow(_scalarLMinus2, _scalarL));

  bool get isZero => v == BigInt.zero;

  /// Каноническое 32-байтное little-endian кодирование.
  List<int> encode() => _bigToLe(v, 32);

  /// Декодирует каноническое little-endian кодирование скаляра; null если >= l.
  static _Scalar? decode(List<int> input) {
    if (input.length != 32) return null;
    final n = _leToBig(input);
    if (n >= _scalarL) return null;
    return _Scalar._(n);
  }

  /// Редукция 64 равномерных байт по модулю l (hash-to-scalar / wide reduce).
  static _Scalar fromUniformBytes(List<int> b) => _Scalar(_leToBig(b));

  /// Случайный ненулевой скаляр (как group.Scalar.Random в bytemare/crypto).
  static _Scalar random() {
    final rnd = Random.secure();
    while (true) {
      final bytes = List<int>.generate(64, (_) => rnd.nextInt(256));
      final s = fromUniformBytes(bytes);
      if (!s.isZero) return s;
    }
  }
}

// ===========================================================================
//  Преобразования little-endian <-> BigInt.
// ===========================================================================

BigInt _leToBig(List<int> b) {
  var r = BigInt.zero;
  for (var i = b.length - 1; i >= 0; i--) {
    r = (r << 8) | BigInt.from(b[i] & 0xff);
  }
  return r;
}

List<int> _bigToLe(BigInt value, int length) {
  final out = List<int>.filled(length, 0);
  var t = value;
  final mask = BigInt.from(0xff);
  for (var i = 0; i < length; i++) {
    out[i] = (t & mask).toInt();
    t = t >> 8;
  }
  return out;
}
