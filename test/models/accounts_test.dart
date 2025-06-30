import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/models/accounts.dart' show Account;

void main() {

  test('Account models', () {
    final account = Account(
      accountId: "5099803df3f4948bd2f98391",
      phone: 7909000000,
      lastName: "Ten",
      firstName: "Alisa",
      username: "alisa",
      bio: "",
    );

    final sqliteMap = account.toSqlite();
    expect(sqliteMap["accountId"], equals("5099803df3f4948bd2f98391"));
    expect(sqliteMap["phone"], equals(7909000000));
    expect(sqliteMap["lastName"], equals("Ten"));
    expect(sqliteMap["firstName"], equals("Alisa"));
    expect(sqliteMap["username"], equals("alisa"));
    expect(sqliteMap["bio"], equals(""));

    final accountObject = Account.fromSqlite(sqliteMap);
    expect(accountObject.accountId, equals("5099803df3f4948bd2f98391"));
    expect(accountObject.phone, equals(7909000000));
    expect(accountObject.lastName, equals("Ten"));
    expect(accountObject.firstName, equals("Alisa"));
    expect(accountObject.username, equals("alisa"));
    expect(accountObject.bio, equals(""));
  });


}
