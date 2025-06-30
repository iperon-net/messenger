import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/models/contacts.dart' show Contact;

void main() {

  test('Account models', () {
    final contact = Contact(
      contactId: "507f191e810c19729de860ea",
      accountId: "5099803df3f4948bd2f98391",
      userId: null,
      firstName: "Lilu",
      lastName: "Kazerogova",
      phone: 79090000000,
    );

    final sqliteMap = contact.toSqlite();

    // print(contact.toSqlite());
    final contactObject = Contact.fromSqlite(sqliteMap);
    print(contactObject);

  });


}
