import 'dart:convert';
import 'dart:typed_data';

import 'crypto.dart';

/// Облачный пароль по OPAQUE-3DH (RFC 9807): на сервер не уходит ни пароль, ни
/// что-либо ему равноценное. Конфигурация общая с сервером
/// (`internal/crypto/opaque.go` в iperon) и **неизменна навсегда**: другой
/// context или параметры KSF — и все установленные пароли перестанут подходить.
const cloudPasswordContext = 'iperon-cloud-password-v1';

/// KSF — Argon2id, 32 MiB, 2 прохода, 4 потока: замедляет офлайн-перебор, если
/// утекут и база, и ключ сервера. 64 MiB / 3 прохода считались ~1,4 с на Pixel 9
/// (pure-Dart Argon2id) — на слабых Android это несколько секунд на каждый ввод.
const cloudPasswordKsf = OpaqueKsf.argon2id(iterations: 2, memory: 32 * 1024, parallelism: 4);

/// Клиент OPAQUE облачного пароля (новый на каждый обмен).
OpaqueClient cloudPasswordClient() => OpaqueClient(context: Uint8List.fromList(utf8.encode(cloudPasswordContext)), ksf: cloudPasswordKsf);

/// Пароль байтами для OPAQUE.
Uint8List cloudPasswordBytes(String password) => Uint8List.fromList(utf8.encode(password));
