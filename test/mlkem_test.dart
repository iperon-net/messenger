import 'package:pqcrypto/pqcrypto.dart';

void main() {
  final kem = PqcKem.kyber768;
  final (pk, sk) = kem.generateKeyPair();
  print('Public Key size: ${pk.length} bytes');
  print('Secret Key size: ${sk.length} bytes');


  final (ct, ssAlice) = kem.encapsulate(pk);
  print(ssAlice);
  print('Ciphertext size: ${ct.length} bytes');

  final ssBob = kem.decapsulate(sk, ct);
  // ssBob

  print(ssBob);
}
