/// Единый источник размеров шрифта для обеих платформ (Cupertino + Material).
///
/// Все размеры выражены как коэффициент от [base], поэтому смена базы
/// масштабирует всю типографику пропорционально. Экраны и темы ссылаются на
/// семантические роли (`caption`, `body`, …), а не на «магические» числа.
///
/// Роли задают лишь *базовый* (логический) размер — системный `textScaler`
/// применяется поверх автоматически виджетом `Text`, поэтому здесь его не
/// домножаем (иначе получилось бы двойное масштабирование).
abstract final class AppFontSizes {
  /// Базовый размер, от которого считаются остальные (Material-роль `bodyLarge`).
  static const double base = 16.0;

  /// Глобальный масштаб текста всего приложения — компактный вид «как было».
  /// Применяется через `MediaQuery.textScaler` в корнях `app_*.dart` и
  /// домножается на пользовательский [SettingsDeviceModel.fontScale].
  static const double uiScale = 0.95;

  /// Границы и шаг пользовательской настройки размера текста (множитель вокруг
  /// 1.0 = «обычный»). Используются слайдером на экране внешнего вида.
  static const double minFontScale = 0.85;
  static const double maxFontScale = 1.30;
  static const int fontScaleDivisions = 9; // шаг 0.05 на диапазоне 0.85..1.30

  /// Ближайшее к [value] допустимое значение множителя, привязанное к сетке
  /// делений слайдера. Защищает от «грязных» значений из БД/UI.
  static double clampFontScale(double value) {
    if (value.isNaN) return 1.0;
    return value.clamp(minFontScale, maxFontScale).toDouble();
  }

  /// 12 — мелкие бейджи (напр. метка текущей сессии).
  static const double badge = base * (12 / 16);

  /// 13 — заголовки секций (uppercase), подписи под контролами, заметки.
  static const double caption = base * (13 / 16);

  /// 14 — подпись поля над значением в Material-профиле (Material-роль `bodyMedium`).
  static const double label = base * (14 / 16);

  /// 15 — заголовки плиток в списках настроек (`ListTile.title`).
  static const double listTitle = base * (15 / 16);

  /// 16 — основной текст и значения плиток.
  static const double body = base;

  /// 17 — значение поля (имя/телефон/username) под подписью.
  static const double value = base * (17 / 16);

  /// 18 — заголовок AppBar.
  static const double appBarTitle = base * (18 / 16);

  /// 20.8 — акцентный текст на экранах авторизации (бывш. `linear(1.3).scale(16)`).
  static const double emphasis = base * 1.3;

  /// 24 — крупный акцент на экранах авторизации (бывш. `linear(1.5).scale(16)`).
  static const double emphasisLarge = base * 1.5;
}
