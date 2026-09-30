import 'dart:ui' show Color;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Резолвинг провайдера ключа доступа (passkey) по AAGUID — идентификатору модели
/// аутентификатора, который сервер сохраняет при регистрации. По нему в списке
/// ключей показываем понятное имя («Apple Password», «Google Password»,
/// …) и иконку. Таблица — публично известные AAGUID популярных менеджеров паролей
/// (FIDO MDS / passkeydeveloper.github.io/passkey-authenticator-aaguids).
///
/// Неизвестный/пустой AAGUID → имя пустое (экран покажет метку ключа или общий
/// «Ключ доступа»), иконка — общий ключ.

/// Категория провайдера — только для выбора иконки.
enum PasskeyProviderKind { apple, google, microsoft, generic }

class PasskeyProvider {
  const PasskeyProvider(this.name, this.kind, {this.asset});
  final String name;
  final PasskeyProviderKind kind;
  // Путь к бренд-SVG (в своих цветах). null → рисуем FaIcon по [kind] в цветном
  // квадрате [passkeyProviderColor].
  final String? asset;
}

// Ключи — канонические UUID в нижнем регистре.
const Map<String, PasskeyProvider> _aaguidProviders = {
  'fbfc3007-154e-4ecc-8c0b-6e020557d7bd': PasskeyProvider(
    'Apple Password',
    PasskeyProviderKind.apple,
    asset: 'assets/icons/passkey_apple.svg',
  ),
  'ea9b8d66-4d01-1d21-3ce4-b6b48cb575d4': PasskeyProvider(
    'Google Password',
    PasskeyProviderKind.google,
    asset: 'assets/icons/passkey_google.svg',
  ),
  '08987058-cadc-4b81-b6e1-30de50dcbe96': PasskeyProvider('Windows Hello', PasskeyProviderKind.microsoft),
  '9ddd1817-af5a-4672-a2b9-3e3dd95000a9': PasskeyProvider('Windows Hello', PasskeyProviderKind.microsoft),
  '6028b017-b1d4-4c02-b4b3-afcdafc96bb2': PasskeyProvider('Windows Hello', PasskeyProviderKind.microsoft),
  'bada5566-a7aa-401f-bd96-45619a55120d': PasskeyProvider(
    '1Password',
    PasskeyProviderKind.generic,
    asset: 'assets/icons/passkey_1password.svg',
  ),
  'd548826e-79b4-db40-a3d8-11116f7e8349': PasskeyProvider(
    'Bitwarden',
    PasskeyProviderKind.generic,
    asset: 'assets/icons/passkey_bitwarden.svg',
  ),
  'b84e4048-15dc-4dd0-8640-f4f60813c8af': PasskeyProvider('NordPass', PasskeyProviderKind.generic),
  '531126d6-e717-415c-9320-3d9aa6981239': PasskeyProvider(
    'Dashlane',
    PasskeyProviderKind.generic,
    asset: 'assets/icons/passkey_dashlane.svg',
  ),
  '531126d6-e717-415c-9320-3d9aa6981240': PasskeyProvider(
    'Dashlane',
    PasskeyProviderKind.generic,
    asset: 'assets/icons/passkey_dashlane.svg',
  ),
  'adce0002-35bc-c60a-648b-0b25f1f05503': PasskeyProvider(
    'Chrome on Mac',
    PasskeyProviderKind.google,
    asset: 'assets/icons/passkey_google.svg',
  ),
  '53414d53-554e-4700-0000-000000000000': PasskeyProvider('Samsung Pass', PasskeyProviderKind.generic),
  'fdb141b2-5d84-443e-8a35-4698c205a502': PasskeyProvider('KeePassXC', PasskeyProviderKind.generic),
  '0ea242b4-43c4-4a1b-8b17-dd6d0b6baec6': PasskeyProvider('Keeper', PasskeyProviderKind.generic),
  '891494da-2c90-4d31-a9cd-4eab0aed1309': PasskeyProvider('ProtonPass', PasskeyProviderKind.generic),
};

/// Канонический UUID (8-4-4-4-12) из 16 байт AAGUID. Пусто, если длина не 16.
String _aaguidToUuid(List<int> aaguid) {
  if (aaguid.length != 16) return '';
  final hex = aaguid.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Провайдер по AAGUID или null, если модель неизвестна.
PasskeyProvider? passkeyProvider(List<int> aaguid) => _aaguidProviders[_aaguidToUuid(aaguid)];

/// Имя провайдера или пустая строка, если неизвестен.
String passkeyProviderName(List<int> aaguid) => passkeyProvider(aaguid)?.name ?? '';

/// Иконка для провайдера (или общий ключ для неизвестного). Тип FaIconData
/// (font_awesome) — рендерить через FaIcon.
FaIconData passkeyProviderIcon(List<int> aaguid) {
  switch (passkeyProvider(aaguid)?.kind) {
    case PasskeyProviderKind.apple:
      return FontAwesomeIcons.apple;
    case PasskeyProviderKind.google:
      return FontAwesomeIcons.google;
    case PasskeyProviderKind.microsoft:
      return FontAwesomeIcons.windows;
    case PasskeyProviderKind.generic:
    case null:
      return FontAwesomeIcons.key;
  }
}

/// Путь к бренд-SVG провайдера (в своих цветах, на белом квадрате) — если у
/// провайдера он задан. `null` → используем [passkeyProviderIcon] (FaIcon в
/// цветном квадрате [passkeyProviderColor]).
String? passkeyProviderIconAsset(List<int> aaguid) => passkeyProvider(aaguid)?.asset;

/// Цвет квадратика иконки провайдера (по образцу цветных иконок в настройках).
/// Иконка внутри — белая, так что цвет должен быть насыщенным.
Color passkeyProviderColor(List<int> aaguid) {
  switch (passkeyProvider(aaguid)?.kind) {
    case PasskeyProviderKind.apple:
      return const Color(0xFF000000);
    case PasskeyProviderKind.google:
      return const Color(0xFF4285F4);
    case PasskeyProviderKind.microsoft:
      return const Color(0xFF0078D4);
    case PasskeyProviderKind.generic:
    case null:
      return const Color(0xFF8E8E93);
  }
}
