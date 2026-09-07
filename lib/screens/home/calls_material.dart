import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../auth.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

/// Вкладка «Звонки» (Android). Фаза 1: временный диалер для теста p2p-звонков —
/// свой userID показываем, чужой вводим руками. Полноценный список
/// вызовов/контактов подключит фаза 3.
class CallsMaterial extends StatefulWidget {
  const CallsMaterial({super.key});

  @override
  State<CallsMaterial> createState() => _CallsMaterialState();
}

class _CallsMaterialState extends State<CallsMaterial> {
  final _controller = TextEditingController();
  final _utils = getIt.get<Utils>();

  String get _myUserID => _utils.bytesToHex(Uint8List.fromList(getIt.get<Auth>().session.userID));

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _myUserID));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('userID скопирован')));
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
    return Scaffold(
      appBar: AppBar(title: Text(context.t.screenHome.calls)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Мой userID (для звонка с другого устройства):'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SelectableText(_myUserID, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(icon: const Icon(Icons.copy), tooltip: 'Скопировать', onPressed: _copy),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'userID собеседника (hex, 24 символа)', border: OutlineInputBorder()),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]'))],
              maxLength: 24,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => _start(false), child: const Text('Аудиозвонок')),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => _start(true), child: const Text('Видеозвонок')),
          ],
        ),
      ),
    );
  }
}
