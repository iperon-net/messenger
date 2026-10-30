import 'package:material_ui/material_ui.dart';

import '../../i18n/translations.g.dart';
import 'report_common.dart';

/// «Пожаловаться» (Android): нижний лист с причиной и необязательным
/// комментарием. Ушла — «Спасибо» снизу; ошибка (нет сети, лимит) — тоже
/// снизу, лист остаётся.
Future<void> showReportMaterial(BuildContext context, ReportTarget target) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReportSheet(target: target),
  );
  if ((sent ?? false) && context.mounted) messenger?.showSnackBar(SnackBar(content: Text(context.t.report.thanks)));
}

class _ReportSheet extends StatefulWidget {
  final ReportTarget target;

  const _ReportSheet({required this.target});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _comment = TextEditingController();
  ReportReason? _reason;
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final reason = _reason;
    if (reason == null || _sending) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final error = await submitReport(context.t, widget.target, reason, _comment.text);
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _sending = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    // С клавиатурой лист не выше свободного места: шапка с закрытием всегда
    // видна, список прокручивается.
    final available = screenHeight - keyboard - MediaQuery.paddingOf(context).top - 48;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: available < screenHeight * 0.85 ? available : screenHeight * 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 8, 4),
                child: Row(
                  children: [
                    Expanded(child: Text(t.report.title, style: theme.textTheme.titleLarge)),
                    IconButton(tooltip: t.common.close, icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(false)),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                      child: Text(t.report.question, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                    ),
                    RadioGroup<ReportReason>(
                      groupValue: _reason,
                      onChanged: (reason) => setState(() => _reason = reason),
                      child: Column(
                        children: [
                          for (final reason in reportReasons)
                            RadioListTile<ReportReason>(value: reason, title: Text(reportReasonLabel(t, reason))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: TextField(
                        controller: _comment,
                        maxLength: 1000,
                        minLines: 2,
                        maxLines: 5,
                        autofillHints: null,
                        decoration: InputDecoration(
                          labelText: t.report.comment,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                        child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: FilledButton(
                        onPressed: _reason == null || _sending ? null : _send,
                        child: _sending
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(t.report.send),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
