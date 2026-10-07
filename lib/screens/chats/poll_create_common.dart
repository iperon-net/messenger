import 'package:flutter/widgets.dart';

import '../../models.dart' as models;

/// Черновик опроса (экраны «Новый опрос» Cupertino + Material): вопрос,
/// варианты (2–10), анонимность, мультивыбор, викторина с верным вариантом и
/// пояснением. В канале голосование всегда анонимное.
class PollDraft {
  static const maxOptions = 10;
  static const questionMaxLength = 255;
  static const optionMaxLength = 100;

  final bool channel;
  final question = TextEditingController();
  final explanation = TextEditingController();
  final options = <TextEditingController>[TextEditingController(), TextEditingController()];
  late bool anonymous = true;
  bool multiple = false;
  bool quiz = false;

  /// Верный вариант викторины (индекс в [options]).
  int? correct;

  PollDraft({required this.channel});

  void addOption() {
    if (options.length < maxOptions) options.add(TextEditingController());
  }

  void removeOption(int index) {
    if (options.length <= 2) return;
    options.removeAt(index).dispose();
    final c = correct;
    if (c == index) correct = null;
    if (c != null && c > index) correct = c - 1;
  }

  /// Квиз — один ответ.
  void setQuiz(bool value) {
    quiz = value;
    if (value) multiple = false;
  }

  List<int> get _filled => [
    for (final (i, c) in options.indexed)
      if (c.text.trim().isNotEmpty) i,
  ];

  bool get valid {
    final filled = _filled;
    return question.text.trim().isNotEmpty && filled.length >= 2 && (!quiz || (correct != null && filled.contains(correct)));
  }

  models.MessagePoll build() => models.MessagePoll(
    question: question.text.trim(),
    options: [for (final i in _filled) models.PollOption(text: options[i].text.trim(), correct: quiz && i == correct)],
    anonymous: channel || anonymous,
    multiple: !quiz && multiple,
    quiz: quiz,
    explanation: quiz ? explanation.text.trim() : '',
  );

  void dispose() {
    question.dispose();
    explanation.dispose();
    for (final c in options) {
      c.dispose();
    }
  }
}
