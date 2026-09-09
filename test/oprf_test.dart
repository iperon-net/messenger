import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';

/// Эталонные векторы сгенерированы `github.com/bytemare/voprf@v0.21.0`
/// (шифронабор ristretto255-SHA512, режим VOPRF) — той же библиотекой, что
/// использует сервер (`internal/crypto/voprf.go`). См. docs/plans/functional-stirring-giraffe.md.
Uint8List _hex(String s) {
  final out = Uint8List(s.length ~/ 2);
  for (var i = 0; i < out.length; i++) {
    out[i] = int.parse(s.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return out;
}

String _hexStr(List<int> b) => b.map((e) => e.toRadixString(16).padLeft(2, '0')).join();

void main() {
  const input = '+79991234567';
  final inputBytes = Uint8List.fromList(input.codeUnits);

  final blind = _hex('0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f00');
  final expectedBlindedElement = _hex('9cd4c30e7550118b9a7f5c29b6cf2bc8dbeaaaabefa5a59ad011e6f583b3427d');
  final evaluation = _hex(
    '000100200c4ea5da60e5c4778284aee21216ec71fc27dd44cc1d4260a391dd75f6cfd27f'
    '495c2eeeee9eabb4570ce2d816f13e99ebfedd7b7e652c324b09cbc707eaef05'
    '49dd5e699cf8031d779ee4a1da0630de31388195883128614fa6e58af9574501',
  );
  final expectedOutput = _hex(
    '89e436bf0fc76faa3e4aa64e939289fd931dbce5663775ffbe1c6bf2a4cd4daf'
    'c37574a9327c4e7a13f421ab8724a24bc71062d9854bbf986737c191d7ee62cf',
  );

  final oprf = Oprf(logger: Logger());

  test('blind(input) с фиксированным blind даёт серверный blindedElement', () async {
    final (_, blindedElement) = await oprf.blind(inputBytes, fixedBlind: blind);
    expect(_hexStr(blindedElement), _hexStr(expectedBlindedElement));
  });

  test('finalize даёт выход == server FullEvaluate (user.oprf)', () async {
    final output = await oprf.finalize(input: inputBytes, blind: blind, evaluation: evaluation);
    expect(_hexStr(output), _hexStr(expectedOutput));
  });
}
