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

Future<T?> _showPicker<T>(BuildContext context, _Picker<T> picker) {
  if (picker.cupertino) {
    return c.showCupertinoModalPopup<T>(context: context, builder: (_) => picker);
  }
  return m.showModalBottomSheet<T>(
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

  const _Picker({
    required this.items,
    required this.title,
    required this.label,
    required this.avatar,
    required this.cupertino,
    this.emptyText,
  });

  @override
  State<_Picker<T>> createState() => _PickerState<T>();
}

class _PickerState<T> extends State<_Picker<T>> {
  String _query = '';

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
                    ],
                  ),
                ],
              ),
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
                          onTap: () => Navigator.of(context).pop(item),
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
                          onTap: () => Navigator.of(context).pop(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
