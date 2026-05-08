part of 'services.dart';

class Auth {
  final Logger logger;
  final phoneUtil = PhoneNumberUtil.instance;

  Auth({required this.logger});


  Future<void> callPassword({required String phoneNumber}) async {

    PhoneNumber phoneNumberParse;
    try {
      phoneNumberParse = phoneUtil.parse(phoneNumber, "");
    } catch (err) {
      rethrow;
    }

    return;
  }

}
