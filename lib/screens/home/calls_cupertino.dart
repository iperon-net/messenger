import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../auth.dart';
import '../../calls.dart';
import '../../components.dart';
import '../../di.dart';
import '../../utils.dart';

/// Вкладка «Звонки» (iOS). Фаза 1: временный диалер для теста p2p-звонков —
/// свой userID показываем, чужой вводим руками. Полноценный список
/// вызовов/контактов подключит фаза 3.
class CallsCupertino extends StatefulWidget {
  const CallsCupertino({super.key});

  @override
  State<CallsCupertino> createState() => _CallsCupertinoState();
}

class _CallsCupertinoState extends State<CallsCupertino> {
  final _controller = TextEditingController();
  final _utils = getIt.get<Utils>();

  bool _copied = false;

  String get _myUserID => _utils.bytesToHex(Uint8List.fromList(getIt.get<Auth>().session.userID));

  void _onCopied() {
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _start(bool video) {
    final hex = _controller.text.trim();
    if (hex.length != 24) return;
    getIt.get<Calls>().startCall(toUserID: _utils.hexToBytes(hex), video: video);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Звонки')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Мой userID (для звонка с другого устройства):'),
              const SizedBox(height: 8),
              CopyTooltip(
                value: _myUserID,
                label: 'Скопировать',
                onCopied: _onCopied,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_myUserID, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Icon(_copied ? CupertinoIcons.checkmark_alt : CupertinoIcons.doc_on_doc, size: 20),
                  ],
                ),
              ),
              if (_copied)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('Скопировано', style: TextStyle(color: CupertinoColors.systemGreen, fontSize: 13)),
                ),
              const SizedBox(height: 24),
              CupertinoTextField(
                controller: _controller,
                placeholder: 'userID собеседника (hex, 24 символа)',
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]'))],
                maxLength: 24,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(onPressed: () => _start(false), child: const Text('Аудиозвонок')),
              const SizedBox(height: 12),
              CupertinoButton.filled(onPressed: () => _start(true), child: const Text('Видеозвонок')),
              const SizedBox(height: 12),
              CupertinoButton(onPressed: () => context.push('/profile/$_myUserID'), child: const Text('Мой профиль')),
            ],
          ),
        ),
      ),
    );
  }
}
