import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../di.dart';
import '../../logger.dart';

/// Собирает журнал (наши call/CallKit-хлебные-крошки + подробные логи LiveKit,
/// заведённые через [attachLiveKitLogging]) в текстовый файл и открывает
/// системное share-меню — чтобы вытащить логи с устройства (AirDrop, почта,
/// «Файлы» и т.п.). Используется обоими экранами «Разработчик».
///
/// Источник — персистентный файловый лог ([Logger.fileLogger]): он переживает
/// перезапуск, поэтому в выгрузку попадают и логи прошлой сессии (например, до
/// краша). На случай пустого файла (сразу после установки) добавляем хвост
/// in-memory истории talker.
Future<void> exportDeviceLogs() async {
  final logger = getIt.get<Logger>();

  final buffer = StringBuffer();
  buffer.write(await logger.fileLogger.readAll());
  if (buffer.isEmpty) {
    for (final data in logger.talker.history) {
      buffer.writeln(data.generateTextMessage());
    }
  }

  final dir = await getTemporaryDirectory();
  final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
  final file = await File('${dir.path}/iperon_logs_$stamp.txt').create(recursive: true);
  await file.writeAsString(buffer.toString());

  await SharePlus.instance.share(ShareParams(files: <XFile>[XFile(file.path)], subject: 'Iperon logs'));
}
