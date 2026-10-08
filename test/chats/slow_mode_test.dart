import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/slow_mode.dart';
import 'package:messenger/models.dart' as models;

void main() {
  test('formatSlowModeLeft', () {
    expect(formatSlowModeLeft(5), '0:05');
    expect(formatSlowModeLeft(65), '1:05');
    expect(formatSlowModeLeft(899), '14:59');
    expect(formatSlowModeLeft(3600), '1:00:00');
  });

  test('slowModeApplies: только группы/сообщества и только не админам', () {
    const group = models.Chat(id: 'g', type: models.ChatType.group, title: 'g', slowMode: 30);
    expect(group.slowModeApplies, isTrue);
    expect(group.copyWith(myRole: models.ChatRole.admin).slowModeApplies, isFalse);
    expect(group.copyWith(myRole: models.ChatRole.owner).slowModeApplies, isFalse);
    expect(group.copyWith(slowMode: 0).slowModeApplies, isFalse);
    expect(group.copyWith(type: models.ChatType.community).slowModeApplies, isTrue);
    expect(group.copyWith(type: models.ChatType.private).slowModeApplies, isFalse);
  });
}
