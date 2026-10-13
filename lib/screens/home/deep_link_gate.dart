import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../deep_links.dart';
import '../chats/chat_common.dart';

/// Открывает ссылки iperon.net, пришедшие снаружи ([DeepLinks]): пользователя
/// — личный чат с ним (как ссылка в сообщении). Не наша ссылка (страница
/// сайта) — во встроенном браузере: в системном её снова перехватило бы
/// приложение. Стоит в шелле вкладок — ссылка, пришедшая до входа, откроется
/// после него.
class DeepLinkGate extends StatefulWidget {
  final Widget child;

  const DeepLinkGate({required this.child, super.key});

  @override
  State<DeepLinkGate> createState() => _DeepLinkGateState();
}

class _DeepLinkGateState extends State<DeepLinkGate> {
  final _links = DeepLinks.instance;

  @override
  void initState() {
    super.initState();
    _links.addListener(_open);
    // Холодный старт: ссылка пришла раньше, чем шелл построился.
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  @override
  void dispose() {
    _links.removeListener(_open);
    super.dispose();
  }

  Future<void> _open() async {
    if (!mounted) return;
    final uri = _links.take();
    if (uri == null) return;
    if (await openIperonLink(context, uri)) return;
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
