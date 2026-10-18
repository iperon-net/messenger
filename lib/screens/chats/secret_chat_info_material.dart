import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chat_no_forwards.dart';
import 'secret_chat_common.dart';

/// «Ключ шифрования» секретного чата (Android): эмодзи и hex отпечатка для
/// сверки с собеседником + удаление чата.
class SecretChatInfoMaterial extends StatelessWidget {
  const SecretChatInfoMaterial({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final t = context.t.secretChat;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.delete),
        content: Text(t.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await context.read<SecretChatCubit>().deleteChat();
  }

  void _notice(BuildContext context, SecretChatState state) {
    if (state.removed) {
      // Чат удалён — закрываем и окно чата под этим экраном.
      context.go('/chats');
      return;
    }
    if (state.notice == SecretChatNotice.offline) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.common.noConnectionTitle)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.secretChat;
    return BlocConsumer<SecretChatCubit, SecretChatState>(
      listenWhen: (previous, current) => previous.noticeCount != current.noticeCount || previous.removed != current.removed,
      listener: _notice,
      builder: (context, state) {
        final theme = Theme.of(context);
        final secondary = theme.colorScheme.onSurfaceVariant;
        return ChatScreenProtector(
          enabled: true,
          child: Scaffold(
            appBar: AppBar(title: Text(t.encryptionKey)),
            body: ListView(
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
                              style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                    title: Text(t.delete, style: TextStyle(color: theme.colorScheme.error)),
                    onTap: () => _confirmDelete(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
