import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Правило папки — тип чатов (включить) или флаг (исключить): строки
/// «Включённые / Исключённые чаты» в редакторе и переключатели на экране
/// выбора чатов. Общее для iOS и Android.
enum ChatFolderRule {
  contacts,
  nonContacts,
  groups,
  channels,
  communities,
  muted,
  read;

  /// Правила для «Добавить чаты».
  static const include = [contacts, nonContacts, groups, channels, communities];

  /// Правила для «Исключить чаты» (как в Telegram, без «Архивных»: архивные в
  /// папки не попадают никогда).
  static const exclude = [muted, read];

  static List<ChatFolderRule> of({required bool include}) => include ? ChatFolderRule.include : ChatFolderRule.exclude;

  String label(Translations t) {
    final s = t.screenChatFolders;
    return switch (this) {
      contacts => s.contacts,
      nonContacts => s.nonContacts,
      groups => s.groups,
      channels => s.channels,
      communities => s.communities,
      muted => s.muted,
      read => s.read,
    };
  }

  FaIconData get icon => switch (this) {
    contacts => FontAwesomeIcons.solidUser,
    nonContacts => FontAwesomeIcons.userSlash,
    groups => FontAwesomeIcons.userGroup,
    channels => FontAwesomeIcons.bullhorn,
    communities => FontAwesomeIcons.layerGroup,
    muted => FontAwesomeIcons.solidBellSlash,
    read => FontAwesomeIcons.checkDouble,
  };

  Color get color => switch (this) {
    contacts => const Color(0xFF1E88E5),
    nonContacts => const Color(0xFF34C759),
    groups => const Color(0xFFFF9500),
    channels => const Color(0xFFFF3B30),
    communities => const Color(0xFFAF52DE),
    muted => const Color(0xFF8E8E93),
    read => const Color(0xFF32ADE6),
  };

  bool isSet(models.ChatFolder folder) => switch (this) {
    contacts => folder.includeContacts,
    nonContacts => folder.includeNonContacts,
    groups => folder.includeGroups,
    channels => folder.includeChannels,
    communities => folder.includeCommunities,
    muted => folder.excludeMuted,
    read => folder.excludeRead,
  };

  models.ChatFolder set(models.ChatFolder folder, bool value) => switch (this) {
    contacts => folder.copyWith(includeContacts: value),
    nonContacts => folder.copyWith(includeNonContacts: value),
    groups => folder.copyWith(includeGroups: value),
    channels => folder.copyWith(includeChannels: value),
    communities => folder.copyWith(includeCommunities: value),
    muted => folder.copyWith(excludeMuted: value),
    read => folder.copyWith(excludeRead: value),
  };
}

String chatFolderTitle(Translations t, models.ChatFolder folder) => folder.isAll ? t.screenChats.allFolder : folder.title;

String chatFolderPresetTitle(Translations t, models.ChatFolderPreset preset) {
  final s = t.screenChatFolders;
  return switch (preset) {
    models.ChatFolderPreset.unread => s.presetUnread,
    models.ChatFolderPreset.personal => s.presetPersonal,
    models.ChatFolderPreset.groups => s.presetGroups,
    models.ChatFolderPreset.channels => s.presetChannels,
  };
}

String chatFolderPresetAbout(Translations t, models.ChatFolderPreset preset) {
  final s = t.screenChatFolders;
  return switch (preset) {
    models.ChatFolderPreset.unread => s.presetUnreadAbout,
    models.ChatFolderPreset.personal => s.presetPersonalAbout,
    models.ChatFolderPreset.groups => s.presetGroupsAbout,
    models.ChatFolderPreset.channels => s.presetChannelsAbout,
  };
}

/// Подпись папки в списке «Мои папки»: число чатов в ней сейчас.
String chatFolderSubtitle(Translations t, int count) => count == 0 ? t.screenChatFolders.noChats : t.screenChatFolders.chatsCount(n: count);

/// Почему папку нельзя сохранить (`null` — можно).
String? chatFolderError(Translations t, models.ChatFolder folder) {
  if (folder.title.trim().isEmpty) return t.screenChatFolders.nameRequired;
  if (!folder.hasIncludes) return t.screenChatFolders.chatsRequired;
  return null;
}

/// Итог экрана выбора чатов: правила [rules] (только своей стороны —
/// включение или исключение) и чаты [chatIDs]. Чат, выбранный на одной
/// стороне, убирается с другой (как в Telegram).
models.ChatFolder withPickedChats(
  models.ChatFolder folder, {
  required bool include,
  required Set<ChatFolderRule> rules,
  required List<String> chatIDs,
}) {
  var result = folder;
  for (final rule in ChatFolderRule.of(include: include)) {
    result = rule.set(result, rules.contains(rule));
  }
  return include
      ? result.copyWith(includeChatIDs: chatIDs, excludeChatIDs: result.excludeChatIDs.where((id) => !chatIDs.contains(id)).toList())
      : result.copyWith(excludeChatIDs: chatIDs, includeChatIDs: result.includeChatIDs.where((id) => !chatIDs.contains(id)).toList());
}

/// Значок правила папки — цветной скруглённый квадрат (как в настройках), по
/// центру ячейки [size]: на iOS строки правил, действий и чатов имеют общую
/// ширину ведущей ячейки, чтобы значки и аватары стояли в одну колонку.
class ChatFolderRuleIcon extends StatelessWidget {
  final ChatFolderRule rule;
  final double size;

  const ChatFolderRuleIcon({super.key, required this.rule, this.size = 30});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: rule.color, borderRadius: BorderRadius.circular(size * 0.24)),
    alignment: Alignment.center,
    child: FaIcon(rule.icon, size: size * 0.5, color: const Color(0xFFFFFFFF)),
  );
}
