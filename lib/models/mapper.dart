import 'package:dart_mappable/dart_mappable.dart';

// Объявляем кастомный маппер для типа bool
class BoolMapper extends SimpleMapper<bool> {
  const BoolMapper();

  @override
  bool decode(dynamic value) {
    print(value);

    // Здесь описываем логику преобразования из JSON в Dart
    if (value == 1) return true;
    if (value == 0) return false;
    // Если пришло уже готовое true/false, просто возвращаем его
    if (value is bool) return value;
    // На случай, если придет что-то другое
    return false;
  }

  @override
  dynamic encode(bool self) {
    print(bool);
    // Здесь описываем логику преобразования из Dart в JSON
    // Возвращаем 1 для true и 0 для false
    return self ? 1 : 0;
  }
}
