import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Значок и цвет плашки устройства в «Устройствах» по коду ОС сессии
/// (`osName` в models/device_info.dart): Apple — синяя, Android — зелёная,
/// Windows — голубая.
FaIconData deviceOsIcon(int os) => switch (os) {
  1 || 3 => FontAwesomeIcons.apple,
  4 => FontAwesomeIcons.windows,
  _ => FontAwesomeIcons.android,
};

Color deviceOsColor(int os) => switch (os) {
  1 || 3 => const Color(0xFF1755DC),
  4 => const Color(0xFF0078D4),
  _ => const Color(0xFF78C257),
};
