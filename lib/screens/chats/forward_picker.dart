import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// «Переслать в…»: лист со списком чатов и поиском по названию. Возвращает
/// выбранный чат или `null` (закрыли).
Future<models.Chat?> showForwardPicker(BuildContext context, List<models.Chat> chats) {
  if (Platform.isIOS) {
    return c.showCupertinoModalPopup<models.Chat>(
      context: context,
      builder: (_) => _ForwardPicker(chats: chats, cupertino: true),
    );
  }
  return m.showModalBottomSheet<models.Chat>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _ForwardPicker(chats: chats, cupertino: false),
  );
}

class _ForwardPicker extends StatefulWidget {
  final List<models.Chat> chats;
  final bool cupertino;

  const _ForwardPicker({required this.chats, required this.cupertino});

  @override
  State<_ForwardPicker> createState() => _ForwardPickerState();
}

class _ForwardPickerState extends State<_ForwardPicker> {
  String _query = '';

  List<models.Chat> _filtered(Translations t) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.chats;
    return widget.chats.where((chat) => ChatTileContent.title(t, chat).toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.cupertino ? _buildCupertino(context) : _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    final t = context.t;
    final chats = _filtered(t);
    final primary = c.CupertinoTheme.of(context).primaryColor;
    final label = c.CupertinoColors.label.resolveFrom(context);
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      decoration: BoxDecoration(
        color: c.CupertinoColors.systemBackground.resolveFrom(context),
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
                    t.screenChat.forwardTo,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: label),
                  ),
                  Row(
                    children: [c.CupertinoButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.common.cancel))],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: c.CupertinoSearchTextField(placeholder: t.screenChat.search, onChanged: (value) => setState(() => _query = value)),
            ),
            Expanded(
              child: chats.isEmpty
                  ? Center(
                      child: Text(
                        t.screenChat.searchNoResults,
                        style: TextStyle(color: c.CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return c.CupertinoListTile(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leadingSize: 42,
                          leading: ChatAvatar(chat: chat, accentColor: primary, size: 42),
                          title: Text(ChatTileContent.title(t, chat)),
                          onTap: () => Navigator.of(context).pop(chat),
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
    final chats = _filtered(t);
    final scheme = m.Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(t.screenChat.forwardTo, style: m.Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: m.SearchBar(
                hintText: t.screenChat.search,
                elevation: const WidgetStatePropertyAll(0),
                leading: const m.Icon(m.Icons.search),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: chats.isEmpty
                  ? Center(child: Text(t.screenChat.searchNoResults))
                  : ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return m.ListTile(
                          leading: ChatAvatar(chat: chat, accentColor: scheme.primary, size: 42),
                          title: Text(ChatTileContent.title(t, chat)),
                          onTap: () => Navigator.of(context).pop(chat),
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
