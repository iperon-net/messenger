import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/screens/chats/chat_folders_common.dart';

void main() {
  group('ChatFolder', () {
    test('sameRules ignores id and title, compares lists deeply', () {
      final preset = models.ChatFolderPreset.groups.folder(id: 'a', title: 'Группы');
      expect(preset.sameRules(const models.ChatFolder(id: 'b', title: 'Мои группы', includeGroups: true)), isTrue);
      expect(preset.sameRules(const models.ChatFolder(id: 'b', includeChannels: true)), isFalse);

      final a = models.ChatFolder(id: 'x', includeChatIDs: ['1', '2']);
      final b = models.ChatFolder(id: 'x', includeChatIDs: ['1', '2']);
      expect(a == b, isTrue);
    });

    test('hasIncludes', () {
      expect(const models.ChatFolder(id: 'x', excludeMuted: true).hasIncludes, isFalse);
      expect(const models.ChatFolder(id: 'x', includeChatIDs: ['1']).hasIncludes, isTrue);
      expect(const models.ChatFolder(id: 'x', includeCommunities: true).hasIncludes, isTrue);
    });
  });

  group('withPickedChats', () {
    const folder = models.ChatFolder(id: 'f', includeGroups: true, excludeMuted: true, includeChatIDs: ['1', '2'], excludeChatIDs: ['3']);

    test('include side replaces include rules and chats, drops them from excluded', () {
      final result = withPickedChats(folder, include: true, rules: {ChatFolderRule.channels}, chatIDs: ['2', '3']);
      expect(result.includeGroups, isFalse);
      expect(result.includeChannels, isTrue);
      expect(result.excludeMuted, isTrue, reason: 'exclude flags untouched');
      expect(result.includeChatIDs, ['2', '3']);
      expect(result.excludeChatIDs, isEmpty);
    });

    test('exclude side replaces exclude flags and chats, drops them from included', () {
      final result = withPickedChats(folder, include: false, rules: {ChatFolderRule.read}, chatIDs: ['1']);
      expect(result.excludeMuted, isFalse);
      expect(result.excludeRead, isTrue);
      expect(result.includeGroups, isTrue, reason: 'include types untouched');
      expect(result.includeChatIDs, ['2']);
      expect(result.excludeChatIDs, ['1']);
    });
  });
}
