part of 'crypto.dart';

/// Группа ristretto255 (RFC 9496) на libsodium (`package:sodium`, FFI): точки и
/// скаляры — 32-байтовые кодировки, скаляры little-endian. Нужна OPAQUE
/// ([OpaqueClient]) и OPRF ([Oprf]); заменила чистый Dart (`ristretto255` поверх
/// `edwards25519` на `BigInt`: ~140 мс на умножение точки и ~3 с на таблицу
/// базовой точки при первом вызове — всё в UI-изоляте).
///
/// Ошибки разбора / вырожденные результаты — `null`: вызывающий превращает их в
/// ошибку протокола.
abstract final class Ristretto255 {
  static const elementLength = 32;
  static const scalarLength = 32;

  static const _sodium = LibSodiumFFI();
  static bool _initialized = false;

  static void _init() {
    if (_initialized) return;
    if (_sodium.sodium_init() < 0) throw StateError('libsodium: sodium_init failed');
    _initialized = true;
  }

  /// Точка из 64 равномерных байт (one-way map RFC 9496 §4.3.4,
  /// `crypto_core_ristretto255_from_hash`) — hash-to-group RFC 9380.
  static Uint8List fromUniform(List<int> uniform) {
    _check(uniform, 64);
    return _run(elementLength, [uniform], (out, args) => _sodium.crypto_core_ristretto255_from_hash(out, args[0]))!;
  }

  /// Скаляр из 64 байт по модулю порядка группы (`scalar_reduce`).
  static Uint8List reduce(List<int> wide) {
    _check(wide, 64);
    return _run(scalarLength, [wide], (out, args) {
      _sodium.crypto_core_ristretto255_scalar_reduce(out, args[0]);
      return 0;
    })!;
  }

  /// `scalar · point`; `null` — точка не разбирается или результат — нейтральный
  /// элемент.
  static Uint8List? mul(List<int> scalar, List<int> point) {
    _check(scalar, scalarLength);
    _check(point, elementLength);
    return _run(elementLength, [scalar, point], (out, args) => _sodium.crypto_scalarmult_ristretto255(out, args[0], args[1]));
  }

  /// `scalar · G`; `null` — нулевой скаляр.
  static Uint8List? mulBase(List<int> scalar) {
    _check(scalar, scalarLength);
    return _run(elementLength, [scalar], (out, args) => _sodium.crypto_scalarmult_ristretto255_base(out, args[0]));
  }

  /// `1 / scalar`; `null` — нулевой скаляр.
  static Uint8List? invert(List<int> scalar) {
    _check(scalar, scalarLength);
    return _run(scalarLength, [scalar], (out, args) => _sodium.crypto_core_ristretto255_scalar_invert(out, args[0]));
  }

  /// Каноническая кодировка точки, не нейтральный элемент (его кодировка — нули).
  static bool isValidElement(List<int> point) {
    if (point.length != elementLength || point.every((b) => b == 0)) return false;
    _init();
    final buffer = calloc<UnsignedChar>(elementLength);
    try {
      buffer.cast<Uint8>().asTypedList(elementLength).setAll(0, point);
      return _sodium.crypto_core_ristretto255_is_valid_point(buffer) == 1;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Скаляр ≠ 0 (нулевой всё равно отсекают [mulBase] / [invert]).
  static bool isZero(List<int> scalar) => scalar.every((b) => b == 0);

  static void _check(List<int> bytes, int length) {
    if (bytes.length != length) throw ArgumentError('ristretto255: expected $length bytes, got ${bytes.length}');
  }

  /// Вызов libsodium: входы копируются в нативные буферы, выход — [outLength]
  /// байт; код возврата ≠ 0 — `null`. Буферы обнуляются и освобождаются.
  static Uint8List? _run(
    int outLength,
    List<List<int>> inputs,
    int Function(Pointer<UnsignedChar> out, List<Pointer<UnsignedChar>> args) call,
  ) {
    _init();
    final out = calloc<UnsignedChar>(outLength);
    final args = [for (final input in inputs) calloc<UnsignedChar>(input.length)];
    try {
      for (var i = 0; i < inputs.length; i++) {
        args[i].cast<Uint8>().asTypedList(inputs[i].length).setAll(0, inputs[i]);
      }
      if (call(out, args) != 0) return null;
      return Uint8List.fromList(out.cast<Uint8>().asTypedList(outLength));
    } finally {
      out.cast<Uint8>().asTypedList(outLength).fillRange(0, outLength, 0);
      calloc.free(out);
      for (var i = 0; i < args.length; i++) {
        args[i].cast<Uint8>().asTypedList(inputs[i].length).fillRange(0, inputs[i].length, 0);
        calloc.free(args[i]);
      }
    }
  }
}
