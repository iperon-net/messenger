import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chats_new_material.dart';
import 'poll_create_common.dart';

/// «Новый опрос» (Android) — скрепка → «Опрос». Результат — опрос или `null`.
Future<models.MessagePoll?> showPollCreateMaterial(BuildContext context, {required bool channel}) {
  return Navigator.of(context).push<models.MessagePoll>(FullSwipeBackRoute(builder: (_) => PollCreateMaterial(channel: channel)));
}

/// Вопрос, варианты (2–10; у викторины кружок слева — верный ответ),
/// настройки (анонимно — не в канале, несколько ответов, викторина) и
/// пояснение викторины. ✓ — когда вопрос и хотя бы 2 варианта.
class PollCreateMaterial extends StatefulWidget {
  final bool channel;

  const PollCreateMaterial({super.key, required this.channel});

  @override
  State<PollCreateMaterial> createState() => _PollCreateMaterial();
}

class _PollCreateMaterial extends State<PollCreateMaterial> {
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

  InputDecoration _decoration(String label, String hint) => InputDecoration(
    labelText: label,
    hintText: hint,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    counterText: '',
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenPoll;
    final scheme = Theme.of(context).colorScheme;
    final valid = _draft.valid;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainerLow,
        title: Text(t.newPoll),
        actions: [
          IconButton(
            tooltip: t.create,
            onPressed: valid ? () => Navigator.of(context).pop(_draft.build()) : null,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            card([
              TextField(
                controller: _draft.question,
                autofocus: true,
                minLines: 1,
                maxLines: 4,
                maxLength: PollDraft.questionMaxLength,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(t.question, t.questionHint),
              ),
            ]),
            createHeaderMaterial(context, t.options),
            card([
              for (final (i, controller) in _draft.options.indexed)
                // Викторина: радиокнопка в той же колонке, что «+» у «Добавить
                // вариант» (центр иконки ListTile — 16 + 12), текст — с 56, как
                // у заголовка ListTile. Подпись поля не нужна (секция и так
                // «Варианты ответа») — только подсказка, иначе кнопка встаёт
                // между подписью и вводом.
                Row(
                  children: [
                    if (_draft.quiz)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Radio<int>(
                          value: i,
                          // ignore: deprecated_member_use
                          groupValue: _draft.correct,
                          // ignore: deprecated_member_use
                          onChanged: (value) => setState(() => _draft.correct = value),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    Expanded(
                      child: TextField(
                        key: ObjectKey(controller),
                        controller: controller,
                        maxLength: PollDraft.optionMaxLength,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: '${t.optionHint} ${i + 1}',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.fromLTRB(_draft.quiz ? 8 : 16, 16, 16, 16),
                        ),
                      ),
                    ),
                    if (_draft.options.length > 2)
                      IconButton(
                        onPressed: () => setState(() => _draft.removeOption(i)),
                        icon: Icon(Icons.remove_circle_outline, color: scheme.error),
                      ),
                  ],
                ),
              if (_draft.options.length < PollDraft.maxOptions)
                ListTile(
                  leading: Icon(Icons.add, color: scheme.primary),
                  title: Text(t.addOption, style: TextStyle(color: scheme.primary)),
                  onTap: () => setState(() {
                    _draft.addOption();
                    _draft.options.last.addListener(_changed);
                  }),
                ),
            ]),
            createNoteMaterial(context, _draft.quiz ? t.quizOptionsFooter : t.optionsFooter),
            createHeaderMaterial(context, t.settings),
            card([
              if (!widget.channel)
                SwitchListTile(
                  title: Text(t.anonymous),
                  value: _draft.anonymous,
                  onChanged: (value) => setState(() => _draft.anonymous = value),
                ),
              SwitchListTile(
                title: Text(t.multiple),
                value: _draft.multiple,
                onChanged: _draft.quiz ? null : (value) => setState(() => _draft.multiple = value),
              ),
              SwitchListTile(title: Text(t.quiz), value: _draft.quiz, onChanged: (value) => setState(() => _draft.setQuiz(value))),
            ]),
            if (_draft.quiz)
              createNoteMaterial(context, t.quizFooter)
            else if (widget.channel)
              createNoteMaterial(context, t.channelFooter),
            if (_draft.quiz) ...[
              const SizedBox(height: 8),
              card([
                TextField(
                  controller: _draft.explanation,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _decoration(t.explanation, t.explanationHint),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
