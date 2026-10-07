import 'package:cupertino_ui/cupertino_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chats_new_cupertino.dart';
import 'poll_create_common.dart';

/// «Новый опрос» (iOS) — скрепка → «Опрос». Результат — опрос или `null`.
Future<models.MessagePoll?> showPollCreateCupertino(BuildContext context, {required bool channel}) {
  return Navigator.of(context).push<models.MessagePoll>(FullSwipeBackRoute(builder: (_) => PollCreateCupertino(channel: channel)));
}

/// Вопрос, варианты (2–10; у викторины кружок слева — верный ответ),
/// настройки (анонимно — не в канале, несколько ответов, викторина) и
/// пояснение викторины. «Создать» — когда вопрос и хотя бы 2 варианта.
class PollCreateCupertino extends StatefulWidget {
  final bool channel;

  const PollCreateCupertino({super.key, required this.channel});

  @override
  State<PollCreateCupertino> createState() => _PollCreateCupertino();
}

class _PollCreateCupertino extends State<PollCreateCupertino> {
  late final _draft = PollDraft(channel: widget.channel);

  @override
  void initState() {
    super.initState();
    _draft.question.addListener(_changed);
    for (final c in _draft.options) {
      c.addListener(_changed);
    }
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenPoll;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final valid = _draft.valid;

    Widget section({String? header, String? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    Widget switchRow(String title, bool value, ValueChanged<bool>? onChanged) => CupertinoListTile(
      title: Text(title, style: const TextStyle(fontSize: AppFontSizes.body)),
      trailing: CupertinoSwitch(value: value, onChanged: onChanged),
    );

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.newPoll),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: valid ? () => Navigator.of(context).pop(_draft.build()) : null,
            child: Text(
              t.create,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valid ? ThemesCupertino.navActionColor(context) : CupertinoColors.inactiveGray.resolveFrom(context),
              ),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            section(
              header: t.question,
              children: [
                CupertinoTextField.borderless(
                  controller: _draft.question,
                  autofocus: true,
                  placeholder: t.questionHint,
                  maxLength: PollDraft.questionMaxLength,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: AppFontSizes.body),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ],
            ),
            section(
              header: t.options,
              footer: _draft.quiz ? t.quizOptionsFooter : t.optionsFooter,
              children: [
                for (final (i, controller) in _draft.options.indexed)
                  Padding(
                    // Викторина: кружок стоит в той же колонке, что «+» у
                    // «Добавить вариант» (отступ и ширина leading у
                    // CupertinoListTile — 20 и 28, до текста — 16).
                    padding: EdgeInsets.only(left: _draft.quiz ? 20 : 12, right: 4),
                    child: Row(
                      children: [
                        // Викторина: кружок — отметить верный ответ.
                        if (_draft.quiz)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => _draft.correct = i),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 28,
                                height: 44,
                                child: Icon(
                                  _draft.correct == i ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                                  color: _draft.correct == i ? const Color(0xFF34C759) : secondary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: CupertinoTextField.borderless(
                            key: ObjectKey(controller),
                            controller: controller,
                            placeholder: '${t.optionHint} ${i + 1}',
                            maxLength: PollDraft.optionMaxLength,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(fontSize: AppFontSizes.body),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                          ),
                        ),
                        if (_draft.options.length > 2)
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(36, 36),
                            onPressed: () => setState(() => _draft.removeOption(i)),
                            child: Icon(CupertinoIcons.minus_circle_fill, color: CupertinoColors.systemRed.resolveFrom(context), size: 22),
                          ),
                      ],
                    ),
                  ),
                if (_draft.options.length < PollDraft.maxOptions)
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.add_circled, color: ThemesCupertino.actionColor(context)),
                    title: Text(t.addOption, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                    onTap: () => setState(() {
                      _draft.addOption();
                      _draft.options.last.addListener(_changed);
                    }),
                  ),
              ],
            ),
            section(
              header: t.settings,
              footer: _draft.quiz ? t.quizFooter : (widget.channel ? t.channelFooter : null),
              children: [
                if (!widget.channel) switchRow(t.anonymous, _draft.anonymous, (value) => setState(() => _draft.anonymous = value)),
                switchRow(t.multiple, _draft.multiple, _draft.quiz ? null : (value) => setState(() => _draft.multiple = value)),
                switchRow(t.quiz, _draft.quiz, (value) => setState(() => _draft.setQuiz(value))),
              ],
            ),
            if (_draft.quiz)
              section(
                header: t.explanation,
                children: [
                  CupertinoTextField.borderless(
                    controller: _draft.explanation,
                    placeholder: t.explanationHint,
                    maxLength: 200,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: AppFontSizes.body),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
