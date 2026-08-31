import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart' show showModalBottomSheet, Colors;

import 'toolbar_attachments_cupertino.dart';
import 'toolbar_attachments_material.dart';

export 'toolbar_attachments_cupertino.dart';
export 'toolbar_attachments_material.dart';

/// Встроенные табы источника медиа. Функционал каждого таба фиксирован внутри
/// компонента; снаружи выбирается только набор доступных табов.
enum ToolbarAttachmentTabKind { camera, gallery, file, emoji, link }

/// Какие типы медиа показывать в галерее. Для аватара — только фото
/// ([image]); для вложений в чат — фото и видео ([all]).
enum ToolbarAttachmentMediaType { image, video, all }

/// Результат выбора, который компонент возвращает наружу.
sealed class ToolbarAttachmentResult {
  const ToolbarAttachmentResult();
}

/// Выбрано одно медиа — фото или видео (камера / галерея / файл).
class ToolbarAttachmentImageResult extends ToolbarAttachmentResult {
  final XFile file;
  final ToolbarAttachmentTabKind source;
  const ToolbarAttachmentImageResult(this.file, this.source);
}

/// Выбрано несколько медиа (мультивыбор в галерее). [files] упорядочены в том
/// порядке, в котором пользователь их отмечал.
class ToolbarAttachmentMultiImageResult extends ToolbarAttachmentResult {
  final List<XFile> files;
  const ToolbarAttachmentMultiImageResult(this.files);
}

/// Выбран эмодзи.
class ToolbarAttachmentEmojiResult extends ToolbarAttachmentResult {
  final String emoji;
  const ToolbarAttachmentEmojiResult(this.emoji);
}

/// Введена / выбрана ссылка.
class ToolbarAttachmentLinkResult extends ToolbarAttachmentResult {
  final String url;
  const ToolbarAttachmentLinkResult(this.url);
}

/// Показывает лист выбора источника медиа (аватар, вложение и т.п.).
///
/// [tabs] — какие табы показать, в этом же порядке. Если передан ровно один
/// таб, нижнее меню-переключатель не отображается.
///
/// [media] фильтрует галерею по типу (фото / видео / всё). [multiSelect]
/// включает мультивыбор: тап по превью отмечает медиа порядковым номером, а
/// кнопка «Готово» возвращает [ToolbarAttachmentMultiImageResult] со всеми
/// отмеченными файлами (в одиночном режиме тап сразу возвращает
/// [ToolbarAttachmentImageResult]).
///
/// Результат приходит двумя путями: как значение возвращаемого [Future] (по
/// закрытию листа) и через необязательный [onResult] (вызывается перед
/// закрытием). Процессы внутри таба (список файлов/картинок и т.д.)
/// реализуются в теле таба и по готовности вызывают возврат результата.
///
/// Cupertino-first: когда появится Material-интерфейс, здесь добавится
/// ветвление на `ToolbarAttachmentsMaterial` по активному дизайну.
///
/// Пример — все табы, результат из [Future] через switch по sealed-типу:
/// ```dart
/// final result = await showToolbarAttachments(
///   context,
///   tabs: const [
///     ToolbarAttachmentTabKind.camera,
///     ToolbarAttachmentTabKind.gallery,
///     ToolbarAttachmentTabKind.file,
///     ToolbarAttachmentTabKind.emoji,
///   ],
/// );
/// if (result == null) return; // лист закрыт без выбора
/// switch (result) {
///   case ToolbarAttachmentImageResult(:final file):  // camera / gallery / file
///     await uploadAvatar(file);
///   case ToolbarAttachmentEmojiResult(:final emoji):
///     setEmojiAvatar(emoji);
///   case ToolbarAttachmentLinkResult(:final url):
///     setAvatarByUrl(url);
/// }
/// ```
///
/// Пример — один таб (меню-переключатель скрывается) + callback вместо Future:
/// ```dart
/// await showToolbarAttachments(
///   context,
///   tabs: const [ToolbarAttachmentTabKind.gallery],
///   onResult: (result) {
///     if (result case ToolbarAttachmentImageResult(:final file)) attach(file);
///   },
/// );
/// ```
Future<ToolbarAttachmentResult?> showToolbarAttachments(
  BuildContext context, {
  required List<ToolbarAttachmentTabKind> tabs,
  ToolbarAttachmentTabKind? initial,
  ToolbarAttachmentMediaType media = ToolbarAttachmentMediaType.image,
  bool multiSelect = false,
  double minChildSize = 0.6,
  double maxChildSize = 0.9,
  ValueChanged<ToolbarAttachmentResult>? onResult,
}) {
  assert(tabs.isNotEmpty, 'Нужен хотя бы один таб');
  final resolvedInitial = initial != null && tabs.contains(initial) ? initial : tabs.first;

  // Выбор дизайна — по платформе, как и весь app-scaffolding (см. main.dart):
  // iOS → Cupertino-лист, Android → Material-лист.
  if (Platform.isIOS) {
    return showCupertinoModalPopup<ToolbarAttachmentResult>(
      context: context,
      builder: (context) => ToolbarAttachmentsCupertino(
        tabs: tabs,
        initial: resolvedInitial,
        media: media,
        multiSelect: multiSelect,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        onResult: onResult,
      ),
    );
  }

  // Material: DraggableScrollableSheet сам управляет высотой, поэтому лист —
  // на всю высоту (`isScrollControlled`) и без своего фона (`transparent`).
  return showModalBottomSheet<ToolbarAttachmentResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ToolbarAttachmentsMaterial(
      tabs: tabs,
      initial: resolvedInitial,
      media: media,
      multiSelect: multiSelect,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      onResult: onResult,
    ),
  );
}
