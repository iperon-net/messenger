// Координаты заведения сообщества (см. «Сообщества» в
// docs/plans/chats-groups-channels.md): по ним строится маршрут в Яндекс
// Картах и 2ГИС.

/// Широта / долгота из поля ввода: «55.650088» (запятая вместо точки — тоже,
/// как на русской цифровой клавиатуре); `null` — не число или по модулю
/// больше [limit] (90 для широты, 180 для долготы).
double? parseCoordinate(String text, {required double limit}) {
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  return value == null || value.abs() > limit ? null : value;
}

/// Карты для маршрута до заведения.
enum MapsApp { yandex, dgis }

/// Ссылки маршрута от текущего места до точки: в приложение карт и запасная —
/// в веб-версию (приложения нет). Яндекс — `rtext=~широта,долгота`, 2ГИС —
/// `directions/points/|долгота,широта` (у 2ГИС долгота первой, см.
/// help.2gis.ru, «Запуск действий в мобильном приложении через deeplink»).
({Uri app, Uri web}) routeUris(MapsApp app, double latitude, double longitude) => switch (app) {
  MapsApp.yandex => (
    app: Uri.parse('yandexmaps://maps.yandex.ru/?rtext=~$latitude,$longitude&rtt=auto'),
    web: Uri.parse('https://yandex.ru/maps/?rtext=~$latitude,$longitude&rtt=auto'),
  ),
  MapsApp.dgis => (
    app: Uri.parse('dgis://2gis.ru/directions/points/%7C$longitude,$latitude'),
    web: Uri.parse('https://2gis.ru/directions/points/%7C$longitude,$latitude'),
  ),
};
