part of 'crypto.dart';

class SHA256 {
  final Logger logger;
  final sha256 = SHA256Digest(); // SHA-256

  SHA256({required this.logger});

  String hexDigest(String value) {
    final hash = sha256.process(utf8.encode(value));
    return hash.map((e) => e.toRadixString(16)).join();
  }

}
