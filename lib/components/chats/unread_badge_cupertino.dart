import 'package:cupertino_ui/cupertino_ui.dart';

import 'chat_tile.dart';
import 'unread_counters.dart';

/// Красный счётчик непрочитанных на иконке вкладки «Чаты» (iOS, как в Telegram).
class UnreadTabIconCupertino extends StatelessWidget {
  final Widget icon;

  const UnreadTabIconCupertino({super.key, required this.icon});

  @override
  Widget build(BuildContext context) => UnreadTotalBuilder(
    builder: (context, total) => Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        if (total > 0)
          Positioned(
            left: 14,
            top: -5,
            child: Container(
              height: 18,
              constraints: const BoxConstraints(minWidth: 18),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: CupertinoColors.systemRed.resolveFrom(context), borderRadius: BorderRadius.circular(9)),
              child: Text(
                ChatTileContent.badge(total),
                style: const TextStyle(color: CupertinoColors.white, fontSize: 12, fontWeight: FontWeight.w600, height: 1.1),
              ),
            ),
          ),
      ],
    ),
  );
}
