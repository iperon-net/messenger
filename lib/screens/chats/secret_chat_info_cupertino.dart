import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'chat_no_forwards.dart';
import 'secret_chat_common.dart';

/// «Ключ шифрования» секретного чата (iOS): эмодзи и hex отпечатка для сверки
/// с собеседником + удаление чата.
class SecretChatInfoCupertino extends StatelessWidget {
  const SecretChatInfoCupertino({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final t = context.t.secretChat;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.delete),
        content: Text(t.deleteConfirm),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await context.read<SecretChatCubit>().deleteChat();
  }

  Future<void> _notice(BuildContext context, SecretChatState state) async {
    if (state.removed) {
      // Чат удалён — закрываем и окно чата под этим экраном.
      context.go('/chats');
      return;
    }
    if (state.notice != SecretChatNotice.offline) return;
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.common.noConnectionTitle),
        content: Text(context.t.common.noConnectionMessage),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.t.common.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.secretChat;
    return BlocConsumer<SecretChatCubit, SecretChatState>(
      listenWhen: (previous, current) => previous.noticeCount != current.noticeCount || previous.removed != current.removed,
      listener: _notice,
      builder: (context, state) {
        final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
        return ChatScreenProtector(
          enabled: true,
          child: CupertinoPageScaffold(
            backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
            navigationBar: CupertinoNavigationBar(previousPageTitle: '', middle: Text(t.encryptionKey)),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: state.emoji.isEmpty
                        ? Text(
                            t.keyNotReady,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: secondary),
                          )
                        : Column(
                            children: [
                              SecretChatFingerprintView(emoji: state.emoji, hex: state.fingerprintHex, hexColor: secondary),
                              const SizedBox(height: 20),
                              Text(
                                t.keyDescription(name: state.title),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: secondary),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(t.delete, style: const TextStyle(color: CupertinoColors.destructiveRed)),
                        onTap: () => _confirmDelete(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
