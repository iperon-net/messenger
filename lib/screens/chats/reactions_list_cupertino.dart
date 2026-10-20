import 'package:cupertino_ui/cupertino_ui.dart';

import '../../chats/reactions_list.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';
import 'reactions_list_common.dart';

/// «Реакции» (iOS): лист снизу — вкладки «Все» и по эмодзи с числами, ниже
/// список «человек — эмодзи» с догрузкой при прокрутке. Тап — профиль.
Future<void> showReactionsListCupertino(
  BuildContext context,
  ReactionsListController controller, {
  required ValueChanged<MessageReactor> onTap,
}) => showCupertinoModalPopup<void>(
  context: context,
  builder: (_) => _ReactionsListCupertino(controller: controller, onTap: onTap),
);

class _ReactionsListCupertino extends StatelessWidget {
  final ReactionsListController controller;
  final ValueChanged<MessageReactor> onTap;

  const _ReactionsListCupertino({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final label = CupertinoColors.label.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final action = ThemesCupertino.actionColor(context);
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.7,
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final state = controller.current;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        t.reactionsList,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(context.t.common.close, style: TextStyle(color: action)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (controller.tabs.length > 1)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        for (final tab in controller.tabs)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: _Tab(
                              text: '${tab.emoji.isEmpty ? t.reactionsListAll : tab.emoji} ${tab.count}',
                              selected: tab.emoji == controller.emoji,
                              onTap: () => controller.select(tab.emoji),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 200) controller.more();
                      return false;
                    },
                    child: ListView(
                      children: [
                        for (final reactor in state.reactors)
                          CupertinoListTile(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            leadingSize: 36,
                            leading: ContactAvatar(
                              contact: models.ChatMember(id: reactor.userID, name: reactor.name),
                              size: 36,
                            ),
                            title: Text(reactor.name),
                            trailing: Text(reactor.emoji, style: const TextStyle(fontSize: 22)),
                            onTap: reactor.isSelf
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                    onTap(reactor);
                                  },
                          ),
                        if (state.loading)
                          const Padding(padding: EdgeInsets.all(16), child: CupertinoActivityIndicator())
                        else if (state.error != ReactionsListError.none)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                            child: Column(
                              children: [
                                Text(
                                  state.error == ReactionsListError.offline ? t.reactionsListOffline : t.reactionsListFailed,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: secondary),
                                ),
                                CupertinoButton(
                                  onPressed: () => controller.more(retry: true),
                                  child: Text(t.reactionsListRetry, style: TextStyle(color: action)),
                                ),
                              ],
                            ),
                          )
                        else if (state.reactors.isEmpty && state.done)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              t.reactionsListEmpty,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: secondary),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Вкладка: «Все 12» / «👍 5»; выбранная — залита акцентом.
class _Tab extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = CupertinoTheme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? accent : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: selected ? ThemesCupertino.onAccent(context) : CupertinoColors.label.resolveFrom(context)),
        ),
      ),
    );
  }
}
