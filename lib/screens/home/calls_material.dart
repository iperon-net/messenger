import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../i18n/translations.g.dart';

/// Вкладка «Звонки» (Android). При первом показе запрашивает доступ к микрофону
/// (нужен для звонков); если доступ не выдан — показывает заглушку с переходом
/// в системные настройки (как на экране «Контакты»). Список последних звонков
/// подключит отдельная задача — пока пустое состояние.
class CallsMaterial extends StatefulWidget {
  const CallsMaterial({super.key});

  @override
  State<CallsMaterial> createState() => _CallsMaterialState();
}

class _CallsMaterialState extends State<CallsMaterial> with WidgetsBindingObserver {
  // null — статус ещё не известен (первая проверка идёт), иначе последний
  // известный статус разрешения на микрофон.
  PermissionStatus? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Первый показ вкладки — осознанный момент запросить доступ к микрофону.
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestOnFirstView());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Возврат из системных настроек — перечитываем статус (доступ могли выдать там).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshStatus();
  }

  /// Первый показ: штатный системный диалог запроса микрофона.
  Future<void> _requestOnFirstView() async {
    final status = await Permission.microphone.request();
    if (mounted) setState(() => _status = status);
  }

  /// Тихая перепроверка статуса без диалога (после возврата из настроек).
  Future<void> _refreshStatus() async {
    final status = await Permission.microphone.status;
    if (mounted) setState(() => _status = status);
  }

  /// Кнопка «Разрешить доступ»: пробуем системный диалог; если система его уже не
  /// показывает (отклонён навсегда) — ведём в настройки приложения. По возврату
  /// оттуда статус подхватит resumed-хук.
  Future<void> _requestAccess() async {
    final status = await Permission.microphone.request();
    if (mounted) setState(() => _status = status);
    if (!status.isGranted) await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.screenCalls.title)),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final status = _status;
    if (status == null) return const Center(child: CircularProgressIndicator());
    if (!status.isGranted) return _permission(context);
    return _empty(context);
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(context.t.screenCalls.empty, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _permission(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic, size: 56),
            const SizedBox(height: 16),
            Text(
              context.t.screenCalls.permissionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(context.t.screenCalls.permissionMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: _requestAccess, child: Text(context.t.screenCalls.allowAccess)),
          ],
        ),
      ),
    );
  }
}
