import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

// Кастомный маппер для типа Uint8List.
// В SQLite BLOB-колонки уже приходят как Uint8List, поэтому декодирование —
// это по сути проверка типа, а кодирование возвращает байты как есть.
class Uint8ListMapper extends SimpleMapper<Uint8List> {
  const Uint8ListMapper();

  @override
  Uint8List decode(dynamic value) {
    if (value is Uint8List) return value;
    if (value is List) return Uint8List.fromList(value.cast<int>());
    return Uint8List(0);
  }

  @override
  dynamic encode(Uint8List self) => self;
}

// Объявляем кастомный маппер для типа bool
class BoolMapper extends SimpleMapper<bool> {
  const BoolMapper();

  @override
  bool decode(dynamic value) {
    if (value == 1) return true;
    if (value == 0) return false;
    if (value is bool) return value;
    return false;
  }

  @override
  dynamic encode(bool self) {
    return self ? 1 : 0;
  }
}
