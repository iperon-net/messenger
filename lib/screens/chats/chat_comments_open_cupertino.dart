import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'chat_common.dart';

/// Комментарии к посту по ссылке `/chats/comments/<канал>/<пост>` (iOS) —
/// тап по пушу ответа / упоминания в ветке: ветка открывается (из кэша или
/// `OpenComments`) и окно заменяется её окном чата. Не вышло (нет сети,
/// комментарии выключены) — пояснение на месте.
class ChatCommentsOpenCupertino extends StatefulWidget {
  final String channelID;
  final String postID;

  /// Прокрутить ветку к этому комментарию (тап в «Ответах»); пусто — нет.
  final String messageID;

  const ChatCommentsOpenCupertino({super.key, required this.channelID, required this.postID, this.messageID = ''});

  @override
  State<ChatCommentsOpenCupertino> createState() => _ChatCommentsOpenCupertinoState();
}

class _ChatCommentsOpenCupertinoState extends State<ChatCommentsOpenCupertino> {
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
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.screenChat.commentsTitle),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: error == null
              ? const CupertinoActivityIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      CupertinoButton(onPressed: _open, child: Text(t.screenChat.retry)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
