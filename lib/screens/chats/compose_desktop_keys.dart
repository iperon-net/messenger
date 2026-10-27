import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../platform.dart';

/// Клавиатура поля ввода на десктопе (как в Telegram Desktop): Enter —
/// отправить, Shift+Enter — перенос строки (поле многострочное, его обычный
/// Enter); с настройкой «Общие → Отправка сообщения» = ⌘/Ctrl+Enter
/// (`sendWithModifierEnter`) отправляет ⌘ (Mac) / Ctrl, а Enter переносит
/// строку. ↑ в пустом поле — изменить последнее своё, Esc — отменить ответ /
/// правку, ⌘/Ctrl+V — вставить картинку или файлы из буфера (текст — как
/// обычно). На мобильных — только [child]. Перехватывает раньше поля:
/// `Shortcuts` над ним срабатывают до `DefaultTextEditingShortcuts`
/// приложения.
class ComposeDesktopKeys extends StatelessWidget {
  const ComposeDesktopKeys({
    super.key,
    required this.input,
    required this.onSend,
    required this.onEditLast,
    required this.onEscape,
    required this.onPaste,
    required this.child,
  });

  final TextEditingController input;
  final VoidCallback onSend;

  /// ↑ в пустом поле; `false` — нечего править (клавиша уходит полю).
  final bool Function() onEditLast;

  /// Esc; `false` — нечего отменять (клавиша уходит дальше).
  final bool Function() onEscape;

  /// ⌘/Ctrl+V: `true` — вставили медиа сами, иначе вставка текста полем.
  final Future<bool> Function() onPaste;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!AppPlatform.isDesktop) return child;
    final modifier = context.select<CommonCubit, bool>((cubit) => cubit.state.settingsDevice.sendWithModifierEnter);
    final mac = Platform.isMacOS;
    return Shortcuts(
      shortcuts: {
        if (modifier) ...{
          SingleActivator(LogicalKeyboardKey.enter, meta: mac, control: !mac): const _SendIntent(),
          SingleActivator(LogicalKeyboardKey.numpadEnter, meta: mac, control: !mac): const _SendIntent(),
        } else ...{
          const SingleActivator(LogicalKeyboardKey.enter): const _SendIntent(),
          const SingleActivator(LogicalKeyboardKey.numpadEnter): const _SendIntent(),
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): const _EditLastIntent(),
        const SingleActivator(LogicalKeyboardKey.escape): const _EscapeIntent(),
        const SingleActivator(LogicalKeyboardKey.keyV, meta: true): const _PasteIntent(),
        const SingleActivator(LogicalKeyboardKey.keyV, control: true): const _PasteIntent(),
      },
      child: Actions(
        actions: {
          _SendIntent: _KeyAction<_SendIntent>(
            // Идёт набор через IME (иероглифы, акценты) — Enter подтверждает его.
            enabled: () => !input.value.composing.isValid || input.value.composing.isCollapsed,
            run: () {
              onSend();
              return true;
            },
          ),
          _EditLastIntent: _KeyAction<_EditLastIntent>(enabled: () => input.text.isEmpty, run: onEditLast),
          _EscapeIntent: _KeyAction<_EscapeIntent>(enabled: () => true, run: onEscape),
          _PasteIntent: _PasteAction(input: input, onPaste: onPaste),
        },
        child: child,
      ),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _EditLastIntent extends Intent {
  const _EditLastIntent();
}

class _EscapeIntent extends Intent {
  const _EscapeIntent();
}

class _PasteIntent extends Intent {
  const _PasteIntent();
}

/// Действие клавиши: [enabled] ложно или [run] вернул `false` — клавиша не
/// поглощается (стрелка двигает курсор в поле, Esc уходит выше).
class _KeyAction<T extends Intent> extends Action<T> {
  _KeyAction({required this.enabled, required this.run});

  final bool Function() enabled;
  final bool Function() run;
  bool _handled = true;

  @override
  bool isEnabled(T intent) => enabled();

  // Не обработали — клавиша идёт дальше вверх по дереву фокуса (Esc закроет
  // экран, если его ловит предок).
  @override
  KeyEventResult toKeyEventResult(T intent, Object? invokeResult) => _handled ? KeyEventResult.handled : KeyEventResult.ignored;

  @override
  Object? invoke(T intent) {
    _handled = run();
    return null;
  }
}

/// ⌘/Ctrl+V: медиа из буфера — [onPaste]; нет — текст в позицию курсора
/// (поле само не вставит: клавишу перехватили до него).
class _PasteAction extends Action<_PasteIntent> {
  _PasteAction({required this.input, required this.onPaste});

  final TextEditingController input;
  final Future<bool> Function() onPaste;

  @override
  Object? invoke(_PasteIntent intent) async {
    if (await onPaste()) return null;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.isEmpty) return null;
    final value = input.value;
    final selection = value.selection.isValid ? value.selection : TextSelection.collapsed(offset: value.text.length);
    input.value = TextEditingValue(
      text: value.text.replaceRange(selection.start, selection.end, text),
      selection: TextSelection.collapsed(offset: selection.start + text.length),
    );
    return null;
  }
}
