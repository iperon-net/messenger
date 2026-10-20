import 'package:material_ui/material_ui.dart';

import '../../chats/reactions_list.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';
import 'reactions_list_common.dart';

/// «Реакции» (Android): bottom sheet — вкладки «Все» и по эмодзи с числами
/// (чипы), ниже список «человек — эмодзи» с догрузкой при прокрутке. Тап —
/// профиль.
Future<void> showReactionsListMaterial(
  BuildContext context,
  ReactionsListController controller, {
  required ValueChanged<MessageReactor> onTap,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => _ReactionsListMaterial(controller: controller, onTap: onTap),
);

class _ReactionsListMaterial extends StatelessWidget {
  final ReactionsListController controller;
  final ValueChanged<MessageReactor> onTap;

  const _ReactionsListMaterial({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final state = controller.current;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(t.reactionsList, style: Theme.of(context).textTheme.titleMedium),
              ),
              if (controller.tabs.length > 1)
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      for (final tab in controller.tabs)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${tab.emoji.isEmpty ? t.reactionsListAll : tab.emoji} ${tab.count}'),
                            selected: tab.emoji == controller.emoji,
                            showCheckmark: false,
                            onSelected: (_) => controller.select(tab.emoji),
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
                        ListTile(
                          leading: ContactAvatar(
                            contact: models.ChatMember(id: reactor.userID, name: reactor.name),
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
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state.error != ReactionsListError.none)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Column(
                            children: [
                              Text(
                                state.error == ReactionsListError.offline ? t.reactionsListOffline : t.reactionsListFailed,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: scheme.onSurfaceVariant),
                              ),
                              TextButton(onPressed: () => controller.more(retry: true), child: Text(t.reactionsListRetry)),
                            ],
                          ),
                        )
                      else if (state.reactors.isEmpty && state.done)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            t.reactionsListEmpty,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.onSurfaceVariant),
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
    );
  }
}
