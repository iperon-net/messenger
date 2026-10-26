import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute;

import '../split_layout.dart';

/// Экран-«лист» поверх приложения на iPad (как form sheet в UIKit): на широком
/// окне — карточка по центру над затемнённым фоном (тап мимо закрывает), на
/// узком — обычный полноэкранный экран. Шаг внутри листа (группа → название) —
/// такая же карточка поверх, без второго затемнения ([dim] = false), и на узком
/// окне он въезжает справа, а не снизу.
class FormSheetPage<T> extends Page<T> {
  final Widget child;
  final bool dim;
  // Android: на узком окне — переход MaterialPageRoute вместо iOS-шторки.
  final bool material;

  const FormSheetPage({super.key, super.name, this.dim = true, this.material = false, required this.child});

  /// Размер карточки: как у системного form sheet.
  static const _size = Size(540, 720);

  @override
  Route<T> createRoute(BuildContext context) {
    if (!SplitLayout.isWide(context)) {
      return material
          ? MaterialPageRoute<T>(settings: this, fullscreenDialog: dim, builder: (_) => child)
          : CupertinoPageRoute<T>(settings: this, fullscreenDialog: dim, builder: (_) => child);
    }
    return PageRouteBuilder<T>(
      settings: this,
      opaque: false,
      barrierDismissible: dim,
      barrierColor: dim ? const Color(0x66000000) : null,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, _, _) => _card(context),
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Widget _card(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = _size.width.clamp(0.0, media.size.width - 32);
    final height = _size.height.clamp(0.0, media.size.height - media.padding.vertical - 32);
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          // Внутри карточки — свои размеры и без системных отступов: навбар
          // экрана не должен опускаться под «чёлку», а список — под таб-бар.
          child: MediaQuery(
            data: media.copyWith(size: Size(width, height), padding: EdgeInsets.zero, viewPadding: EdgeInsets.zero),
            child: child,
          ),
        ),
      ),
    );
  }
}
