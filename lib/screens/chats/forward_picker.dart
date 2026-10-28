import 'dart:io';
import 'dart:typed_data';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../components.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import '../../utils.dart';
import 'chat_create_common.dart';

/// «Переслать в…»: лист со списком чатов и поиском по названию. Возвращает
/// выбранный чат или `null` (закрыли).
Future<models.Chat?> showForwardPicker(BuildContext context, List<models.Chat> chats) => _showPicker(
  context,
  _Picker<models.Chat>(
    items: chats,
    title: (t) => t.screenChat.forwardTo,
    label: ChatTileContent.title,
    avatar: (context, chat, cupertino) => cupertino
        ? ChatAvatar(
            chat: chat,
            accentColor: c.CupertinoTheme.of(context).primaryColor,
            accentForeground: ThemesCupertino.onAccent(context),
            size: 42,
          )
        : ChatAvatar(
            chat: chat,
            accentColor: m.Theme.of(context).colorScheme.primary,
            accentForeground: m.Theme.of(context).colorScheme.onPrimary,
            size: 42,
          ),
    cupertino: Platform.isIOS,
  ),
);

/// Человек в [showUserPicker]: userID и имя по общему правилу.
typedef PickerUser = ({Uint8List userID, String name});

/// Выбор человека (тот же лист, что «Переслать в…»): [title] — заголовок,
/// возвращает выбранного или `null` (закрыли). [emptyText] — вместо «ничего не
/// найдено», когда выбирать не из кого.
Future<PickerUser?> showUserPicker(BuildContext context, {required String title, required List<PickerUser> users, String? emptyText}) =>
    _showPicker(
      context,
      _Picker<PickerUser>(
        items: users,
        title: (_) => title,
        emptyText: emptyText,
        label: (_, user) => user.name,
        avatar: (context, user, _) =>
            UserAvatar(userID: user.userID, placeholderName: getIt.get<Utils>().bytesToHex(user.userID), size: 42),
        cupertino: Platform.isIOS,
      ),
    );

/// Выбор нескольких человек (тот же лист, отметки галочками): не больше [max],
/// кнопка [action] возвращает выбранных; `null` — закрыли.
Future<List<PickerUser>?> showUsersPicker(
  BuildContext context, {
  required String title,
  required List<PickerUser> users,
  required int max,
  required String action,
  String? emptyText,
}) => _showPicker(
  context,
  _Picker<PickerUser>(
    items: users,
    title: (_) => title,
    emptyText: emptyText,
    label: (_, user) => user.name,
    avatar: (context, user, _) => UserAvatar(userID: user.userID, placeholderName: getIt.get<Utils>().bytesToHex(user.userID), size: 42),
    cupertino: Platform.isIOS,
    max: max,
    action: action,
  ),
);

/// Выбор участника / контакта (тот же лист): аватар и имя участника.
Future<models.ChatMember?> showMemberPicker(
  BuildContext context, {
  required String title,
  required List<models.ChatMember> members,
  String? emptyText,
}) => _showPicker(
  context,
  _Picker<models.ChatMember>(
    items: members,
    title: (_) => title,
    emptyText: emptyText,
    label: (_, member) => member.name,
    avatar: (context, member, _) => ContactAvatar(contact: member, size: 42),
    cupertino: Platform.isIOS,
  ),
);

Future<R?> _showPicker<R, T>(BuildContext context, _Picker<T> picker) {
  if (picker.cupertino) {
    return c.showCupertinoModalPopup<R>(context: context, builder: (_) => picker);
  }
  return m.showModalBottomSheet<R>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => picker,
  );
}

class _Picker<T> extends StatefulWidget {
  final List<T> items;
  final String Function(Translations t) title;
  final String Function(Translations t, T item) label;
  final Widget Function(BuildContext context, T item, bool cupertino) avatar;
  final bool cupertino;
  final String? emptyText;

  /// Выбор нескольких: не больше [max], [action] — кнопка «готово» (лист вернёт
  /// `List<T>`). `null` — выбор одного по тапу.
  final int? max;
  final String? action;

  const _Picker({
    required this.items,
    required this.title,
    required this.label,
    required this.avatar,
    required this.cupertino,
    this.emptyText,
    this.max,
    this.action,
  });

  @override
  State<_Picker<T>> createState() => _PickerState<T>();
}

class _PickerState<T> extends State<_Picker<T>> {
  String _query = '';
  final _selected = <T>[];

  bool get _multi => widget.max != null;

  void _tap(T item) {
    if (!_multi) {
      Navigator.of(context).pop(item);
      return;
    }
    setState(() {
      if (!_selected.remove(item) && _selected.length < widget.max!) _selected.add(item);
    });
  }

  void _done() => Navigator.of(context).pop(List<T>.of(_selected));

  /// Пусто: выбирать не из кого ([_Picker.emptyText]) или поиск ничего не нашёл.
  String _emptyText(Translations t) =>
      widget.items.isEmpty ? (widget.emptyText ?? t.screenChat.searchNoResults) : t.screenChat.searchNoResults;

  List<T> _filtered(Translations t) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.items;
    return widget.items.where((item) => widget.label(t, item).toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.cupertino ? _buildCupertino(context) : _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    final t = context.t;
    final items = _filtered(t);
    final label = c.CupertinoColors.label.resolveFrom(context);
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      decoration: BoxDecoration(
        // Фон приложения (в тёмной теме — синий), а не системный чёрный.
        color: ThemesCupertino.appBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.title(t),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                  ),
                  Row(
                    children: [
                      c.CupertinoButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(t.common.cancel, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                      ),
                      const Spacer(),
                      if (_multi)
                        c.CupertinoButton(
                          onPressed: _selected.isEmpty ? null : _done,
                          child: Text(
                            widget.action!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _selected.isEmpty
                                  ? c.CupertinoColors.tertiaryLabel.resolveFrom(context)
                                  : ThemesCupertino.actionColor(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (_multi)
              Text(
                t.screenCalls.pickSelected(n: _selected.length, max: widget.max!),
                style: TextStyle(fontSize: 13, color: c.CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: c.CupertinoSearchTextField(placeholder: t.screenChat.search, onChanged: (value) => setState(() => _query = value)),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _emptyText(t),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: c.CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return c.CupertinoListTile(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leadingSize: 42,
                          leading: widget.avatar(context, item, true),
                          title: Text(widget.label(t, item)),
                          trailing: _multi ? _checkCupertino(context, _selected.contains(item)) : null,
                          onTap: () => _tap(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final t = context.t;
    final items = _filtered(t);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(widget.title(t), style: m.Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              // Обычное поле с тонкой рамкой из темы: SearchBar рисовал свою
              // «таблетку», а внутри — ещё и рамку TextField (двойной контур).
              child: m.TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: m.InputDecoration(
                  hintText: t.screenChat.search,
                  prefixIcon: const m.Icon(m.Icons.search, size: 20),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(_emptyText(t), textAlign: TextAlign.center),
                      ),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return m.ListTile(
                          leading: widget.avatar(context, item, false),
                          title: Text(widget.label(t, item)),
                          trailing: _multi ? m.Checkbox(value: _selected.contains(item), onChanged: (_) => _tap(item)) : null,
                          onTap: () => _tap(item),
                        );
                      },
                    ),
            ),
            if (_multi)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: m.FilledButton(
                      onPressed: _selected.isEmpty ? null : _done,
                      child: Text('${widget.action!} · ${t.screenCalls.pickSelected(n: _selected.length, max: widget.max!)}'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Отметка выбранного в листе (iOS): закрашенный кружок с галочкой / пустой.
Widget _checkCupertino(BuildContext context, bool selected) => Icon(
  selected ? c.CupertinoIcons.checkmark_circle_fill : c.CupertinoIcons.circle,
  size: 24,
  color: selected ? c.CupertinoTheme.of(context).primaryColor : c.CupertinoColors.tertiaryLabel.resolveFrom(context),
);
