import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:image_picker/image_picker.dart';

import 'media_source_sheet_cupertino.dart';

export 'media_source_sheet_cupertino.dart';

/// Встроенные табы источника медиа. Функционал каждого таба фиксирован внутри
/// компонента; снаружи выбирается только набор доступных табов.
enum MediaSourceTabKind { camera, gallery, file, emoji, link }

/// Результат выбора, который компонент возвращает наружу.
sealed class MediaSourceResult {
  const MediaSourceResult();
}

/// Выбрано изображение (камера / галерея / файл).
class MediaImageResult extends MediaSourceResult {
  final XFile file;
  final MediaSourceTabKind source;
  const MediaImageResult(this.file, this.source);
}

/// Выбран эмодзи.
class MediaEmojiResult extends MediaSourceResult {
  final String emoji;
  const MediaEmojiResult(this.emoji);
}

/// Введена / выбрана ссылка.
class MediaLinkResult extends MediaSourceResult {
  final String url;
  const MediaLinkResult(this.url);
}

/// Показывает лист выбора источника медиа (аватар, вложение и т.п.).
///
/// [tabs] — какие табы показать, в этом же порядке. Если передан ровно один
/// таб, нижнее меню-переключатель не отображается.
///
/// Результат приходит двумя путями: как значение возвращаемого [Future] (по
/// закрытию листа) и через необязательный [onResult] (вызывается перед
/// закрытием). Процессы внутри таба (список файлов/картинок и т.д.)
/// реализуются в теле таба и по готовности вызывают возврат результата.
///
/// Cupertino-first: когда появится Material-интерфейс, здесь добавится
/// ветвление на `MediaSourceSheetMaterial` по активному дизайну.
///
/// Пример — все табы, результат из [Future] через switch по sealed-типу:
/// ```dart
/// final result = await showMediaSourceSheet(
///   context,
///   tabs: const [
///     MediaSourceTabKind.camera,
///     MediaSourceTabKind.gallery,
///     MediaSourceTabKind.file,
///     MediaSourceTabKind.emoji,
///   ],
/// );
/// if (result == null) return; // лист закрыт без выбора
/// switch (result) {
///   case MediaImageResult(:final file):  // camera / gallery / file
///     await uploadAvatar(file);
///   case MediaEmojiResult(:final emoji):
///     setEmojiAvatar(emoji);
///   case MediaLinkResult(:final url):
///     setAvatarByUrl(url);
/// }
/// ```
///
/// Пример — один таб (меню-переключатель скрывается) + callback вместо Future:
/// ```dart
/// await showMediaSourceSheet(
///   context,
///   tabs: const [MediaSourceTabKind.gallery],
///   onResult: (result) {
///     if (result case MediaImageResult(:final file)) attach(file);
///   },
/// );
/// ```
Future<MediaSourceResult?> showMediaSourceSheet(
  BuildContext context, {
  required List<MediaSourceTabKind> tabs,
  MediaSourceTabKind? initial,
  double minChildSize = 0.6,
  double maxChildSize = 0.9,
  ValueChanged<MediaSourceResult>? onResult,
}) {
  assert(tabs.isNotEmpty, 'Нужен хотя бы один таб');
  return showCupertinoModalPopup<MediaSourceResult>(
    context: context,
    builder: (context) => MediaSourceSheetCupertino(
      tabs: tabs,
      initial: initial != null && tabs.contains(initial) ? initial : tabs.first,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      onResult: onResult,
    ),
  );
}
