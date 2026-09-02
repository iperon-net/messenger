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
