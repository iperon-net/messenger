import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chat_common.dart';

/// Комментарии к посту по ссылке `/chats/comments/<канал>/<пост>` (Android) —
/// тап по пушу ответа / упоминания в ветке: ветка открывается (из кэша или
/// `OpenComments`) и окно заменяется её окном чата. Не вышло (нет сети,
/// комментарии выключены) — пояснение на месте.
class ChatCommentsOpenMaterial extends StatefulWidget {
  final String channelID;
  final String postID;

  /// Прокрутить ветку к этому комментарию (тап в «Ответах»); пусто — нет.
  final String messageID;

  const ChatCommentsOpenMaterial({super.key, required this.channelID, required this.postID, this.messageID = ''});

  @override
  State<ChatCommentsOpenMaterial> createState() => _ChatCommentsOpenMaterialState();
}

class _ChatCommentsOpenMaterialState extends State<ChatCommentsOpenMaterial> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    if (!mounted) return;
    setState(() => _error = null);
    final result = await openCommentsThread(
      context.t,
      demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
      channelID: widget.channelID,
      postID: widget.postID,
    );
    if (!mounted) return;
    if (result.threadID.isNotEmpty) {
      final focus = widget.messageID.isEmpty ? '' : '?message=${widget.messageID}';
      context.replace('/chats/chat/${result.threadID}$focus');
      return;
    }
    setState(() => _error = result.error);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final error = _error;
    return Scaffold(
      appBar: AppBar(title: Text(t.screenChat.commentsTitle)),
      body: Center(
        child: error == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _open, child: Text(t.screenChat.retry)),
                  ],
                ),
              ),
      ),
    );
  }
}
