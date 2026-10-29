import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'report_common.dart';

/// «Пожаловаться» (iOS): лист с причиной и необязательным комментарием.
/// Ушла — лист закрывается и «Спасибо»; ошибка (нет сети, лимит) — алерт,
/// лист остаётся.
Future<void> showReportCupertino(BuildContext context, ReportTarget target) async {
  final sent = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (_) => _ReportSheet(target: target),
  );
  if ((sent ?? false) && context.mounted) showChatToast(context, context.t.report.thanks);
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

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final reason = _reason;
    if (reason == null || _sending) return;
    setState(() => _sending = true);
    final t = context.t;
    final error = await submitReport(t, widget.target, reason, _comment.text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.report.title),
        content: Text(error),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.ok))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final label = CupertinoColors.label.resolveFrom(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final accent = ThemesCupertino.actionColor(context);

    return Padding(
      // Лист поднимается над клавиатурой.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        decoration: BoxDecoration(
          color: ThemesCupertino.groupedBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    NavBarButtonCupertino(NavBarAction.cancel, onPressed: () => Navigator.of(context).pop(false)),
                    Expanded(
                      child: Text(
                        t.report.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSizes.body, color: label),
                      ),
                    ),
                    NavBarButtonCupertino(
                      NavBarAction.done,
                      label: t.report.send,
                      loading: _sending,
                      onPressed: _reason == null ? null : _send,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: Text(t.report.question, style: TextStyle(color: secondary)),
                    ),
                    CupertinoListSection.insetGrouped(
                      children: [
                        for (final reason in reportReasons)
                          CupertinoListTile(
                            title: Text(reportReasonLabel(t, reason)),
                            trailing: _reason == reason ? Icon(CupertinoIcons.check_mark, color: accent) : null,
                            onTap: () => setState(() => _reason = reason),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: CupertinoTextField(
                        controller: _comment,
                        placeholder: t.report.comment,
                        maxLength: 1000,
                        minLines: 2,
                        maxLines: 5,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ThemesCupertino.groupedCard.resolveFrom(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
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
