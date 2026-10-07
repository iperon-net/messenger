import 'package:intl/intl.dart';

extension IntFormatExtension on int {
  /// Число с разбивкой на разряды по локали intl: «44 000» (ru), «44,000» (en).
  String get grouped => NumberFormat.decimalPattern().format(this);
}
