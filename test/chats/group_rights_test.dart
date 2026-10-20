import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/group_rights.dart';
import 'package:messenger/models.dart' as models;

// Общая таблица прав в группе (подэтап 3.2): тот же файл, байт-в-байт, лежит
// на сервере (iperon/internal/services/testdata/group_rights_cases.json) и
// прогоняется его функцией прав. Здесь — каждый кейс через клиентские
// функции, которые прячут кнопки на экранах (lib/chats/group_rights.dart).
void main() {
  final fixture = jsonDecode(File('test/chats/fixtures/group_rights_cases.json').readAsStringSync()) as Map<String, dynamic>;
  final cases = (fixture['cases'] as List).cast<Map<String, dynamic>>();

  models.ChatRole role(String name) => switch (name) {
    'reader' => models.ChatRole.reader,
    'writer' => models.ChatRole.writer,
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
        'pinMessages' => r.copyWith(pinMessages: true),
        'manageCalls' => r.copyWith(manageCalls: true),
        'anonymous' => r.copyWith(anonymous: true),
        'addAdmins' => r.copyWith(addAdmins: true),
        _ => throw ArgumentError('неизвестное право $name'),
      };
    }
    return r;
  }

  test('таблица не пустая и все права известны', () {
    expect(cases, isNotEmpty);
    rights(fixture['rights'] as List);
  });

  // Права «моего» участника: [fromDialog] — как с сервера (Chat.myRights из
  // Dialog.rights), иначе — как в демо (по участнику «Вы»).
  for (final fromDialog in [true, false]) {
    group(fromDialog ? 'права из диалога (сервер)' : 'права по участнику «Вы» (демо)', () {
      for (final c in cases) {
        test('${c['action']}: ${c['name']}', () {
          final actor = c['actor'] as Map<String, dynamic>;
          final actorRole = role(actor['role'] as String);
          final actorRights = rights(actor['rights'] as List);
          final chat = models.Chat(
            id: 'g',
            type: models.ChatType.group,
            title: 'Группа',
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
              name: 'Участник',
              role: role(t['role'] as String),
              rights: rights(t['rights'] as List),
            ),
            _ => throw ArgumentError('неизвестная цель $rawTarget'),
          };
          if (target != null) members.add(target);
          final requested = rights(c['requested'] as List? ?? const []);

          final got = switch (c['action'] as String) {
            'send' => canSendInGroup(chat.myRole),
            'setMemberRole' || 'removeMember' || 'ban' => canRestrictMember(chat, members, target!),
            'setAdmin' => canSetAdmin(chat, members, target!, requested),
            'removeAdmin' => canRemoveAdmin(chat, members, target!),
            'editInfo' => canEditChatInfo(chat, members),
            'deleteOthers' => canDeleteOthers(chat, members),
            'pinForAll' => canPinForAll(chat, members),
            'unban' => canUnbanMembers(chat, members),
            'addBanned' => canAddBanned(chat, members),
            'transferOwnership' => canTransferOwnership(chat, target!),
            'setOwnRank' => canSetOwnRank(chat, target!),
            'banNonMember' => canBanNonMember(chat, members),
            final action => throw ArgumentError('неизвестное действие $action'),
          };
          expect(got, c['expect'] as bool);
        });
      }
    });
  }
}
