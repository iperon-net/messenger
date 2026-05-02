import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:objectid/objectid.dart';


void main() {

  test('logger', () {
    // final userID = [54, 57, 102, 52, 54, 100, 54, 53, 51, 97, 98, 101, 52, 53, 56, 48, 101, 99, 56, 54, 99, 98, 99, 50];
    final userID = [95, 82, 205, 121, 180, 195, 28, 88, 32, 47, 183, 78];
    final userObjectID = ObjectId.fromBytes(userID);
    print(userID.length);

  });
}
