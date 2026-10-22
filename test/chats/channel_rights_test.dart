import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/channel_rights.dart';
import 'package:messenger/models.dart' as models;

// Общая таблица прав в канале (подэтап 4.1): тот же файл, байт-в-байт, лежит
// на сервере (iperon/internal/services/testdata/channel_rights_cases.json) и
// прогоняется его функцией прав. Здесь — каждый кейс через channelCan
// (lib/chats/channel_rights.dart), которым экраны прячут кнопки.
void main() {
  final fixture = jsonDecode(File('test/chats/fixtures/channel_rights_cases.json').readAsStringSync()) as Map<String, dynamic>;
  final cases = (fixture['cases'] as List).cast<Map<String, dynamic>>();

  models.ChatRole role(String name) => switch (name) {
    'reader' => models.ChatRole.reader,
    'admin' => models.ChatRole.admin,
    'owner' => models.ChatRole.owner,
    _ => throw ArgumentError('неизвестная роль $name'),
  };

  models.ChatAdminRights rights(List<dynamic> names) {
    var r = const models.ChatAdminRights();
    for (final name in names.cast<String>()) {
      r = switch (name) {
        'changeInfo' => r.copyWith(changeInfo: true),
        'postMessages' => r.copyWith(postMessages: true),
        'editMessages' => r.copyWith(editMessages: true),
        'deleteMessages' => r.copyWith(deleteMessages: true),
        'banUsers' => r.copyWith(banUsers: true),
        'inviteUsers' => r.copyWith(inviteUsers: true),
        'manageCalls' => r.copyWith(manageCalls: true),
        'addAdmins' => r.copyWith(addAdmins: true),
        _ => throw ArgumentError('неизвестное право $name'),
      };
    }
    return r;
  }

  test('таблица не пустая, права и действия известны', () {
    expect(cases, isNotEmpty);
    rights(fixture['rights'] as List);
    for (final c in cases) {
      expect(ChannelAction.values.map((a) => a.name), contains(c['action']));
    }
  });

  for (final fromDialog in [true, false]) {
    group(fromDialog ? 'права из диалога (сервер)' : 'права по участнику «Вы» (демо)', () {
      for (final c in cases) {
        test('${c['action']}: ${c['name']}', () {
          final actor = c['actor'] as Map<String, dynamic>;
          final actorRole = role(actor['role'] as String);
          final actorRights = rights(actor['rights'] as List);
          final chat = models.Chat(
            id: 'c',
            type: models.ChatType.channel,
            title: 'Канал',
            myRole: actorRole,
            myRights: fromDialog && actorRole == models.ChatRole.admin ? actorRights : null,
          );
          final self = models.ChatMember(id: 'me', name: 'Я', role: actorRole, rights: actorRights, isSelf: true);
          final members = [self];
          final rawTarget = c['target'];
          final models.ChatMember? target = switch (rawTarget) {
            null => null,
            'self' => self,
            final Map<String, dynamic> t => models.ChatMember(
              id: 'other',
              name: 'Подписчик',
              role: role(t['role'] as String),
              rights: rights(t['rights'] as List),
            ),
            _ => throw ArgumentError('неизвестная цель $rawTarget'),
          };
          if (target != null) members.add(target);
          final got = channelCan(
            chat,
            members,
            ChannelAction.values.byName(c['action'] as String),
            target: target,
            requested: rights(c['requested'] as List? ?? const []),
          );
          expect(got, c['expect'] as bool);
        });
      }
    });
  }
}
