import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/member_badge.dart';
import 'package:messenger/models.dart' as models;

// Подпись отправителя в пузыре группы (хвост 3.2): звание, без звания —
// «владелец» / «админ»; у остальных и неизвестных — пусто.
void main() {
  const owner = 'владелец';
  const admin = 'админ';

  test('звание важнее роли, без звания — роль', () {
    expect(
      senderBadge(
        const models.ChatMember(id: 'a', name: 'А', role: models.ChatRole.owner),
        owner: owner,
        admin: admin,
      ),
      owner,
    );
    expect(
      senderBadge(
        const models.ChatMember(id: 'a', name: 'А', role: models.ChatRole.owner, rank: ' Основатель '),
        owner: owner,
        admin: admin,
      ),
      'Основатель',
    );
    expect(
      senderBadge(
        const models.ChatMember(id: 'b', name: 'Б', role: models.ChatRole.admin),
        owner: owner,
        admin: admin,
      ),
      admin,
    );
    expect(
      senderBadge(
        const models.ChatMember(id: 'b', name: 'Б', role: models.ChatRole.admin, rank: 'Модератор'),
        owner: owner,
        admin: admin,
      ),
      'Модератор',
    );
  });

  test('участник и читатель — без подписи (звание у них не показывается)', () {
    expect(
      senderBadge(
        const models.ChatMember(id: 'c', name: 'В', rank: 'старое'),
        owner: owner,
        admin: admin,
      ),
      isEmpty,
    );
    expect(
      senderBadge(
        const models.ChatMember(id: 'd', name: 'Г', role: models.ChatRole.reader),
        owner: owner,
        admin: admin,
      ),
      isEmpty,
    );
  });

  test('senderBadges — только непустые, по userID; кого нет в кэше — без подписи', () {
    final badges = senderBadges(
      const [
        models.ChatMember(id: 'a', name: 'А', role: models.ChatRole.owner),
        models.ChatMember(id: 'b', name: 'Б', role: models.ChatRole.admin, rank: 'Модератор'),
        models.ChatMember(id: 'c', name: 'В'),
      ],
      owner: owner,
      admin: admin,
    );
    expect(badges, {'a': owner, 'b': 'Модератор'});
    expect(badges['неизвестный'], isNull);
  });
}
