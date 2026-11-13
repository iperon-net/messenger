import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Тесты чистой нормализации (план 01-contacts-loading, шаг 2): она вызывается
  // и в UI-isolate, и в фоновом изоляте книги — проверяем оба пути.
  group('Utils.normalizePhone', () {
    test('нормализует RU-мобильный с кодом страны', () {
      final normalization = Utils.normalizePhone(phoneNumber: '+7 963 655-41-87');
      expect(normalization.e164, '+79636554187');
      expect(normalization.raw, '79636554187');
      expect(normalization.international, isNotEmpty);
    });

    test('нормализует 8-ку как 7-ку', () {
      final normalization = Utils.normalizePhone(phoneNumber: '8 (918) 327-00-17');
      expect(normalization.e164, '+79183270017');
    });

    test('RU-мобильный без кода страны считается российским', () {
      final normalization = Utils.normalizePhone(phoneNumber: '9183270017');
      expect(normalization.e164, '+79183270017');
    });

    test('мусор и иностранная экзотика без кода — пустая модель', () {
      expect(Utils.normalizePhone(phoneNumber: 'abc').e164, isEmpty);
      expect(Utils.normalizePhone(phoneNumber: '12345').e164, isEmpty);
    });

    test('работает в свежем изоляте (dlibphonenumber — чистый Dart)', () async {
      final e164 = await Isolate.run(() => Utils.normalizePhone(phoneNumber: '+7 921 276-52-85').e164);
      expect(e164, '+79212765285');
    });

    test('инстансный phoneNormalization делегирует статике', () {
      final utils = Utils();
      addTearDown(utils.dispose);
      final normalization = utils.phoneNormalization(phoneNumber: '+7 985 424-38-95');
      expect(normalization.e164, '+79854243895');
      expect(normalization.e164, Utils.normalizePhone(phoneNumber: '+7 985 424-38-95').e164);
    });
  });
}
