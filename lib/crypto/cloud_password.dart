import 'dart:convert';
import 'dart:typed_data';

import 'crypto.dart';

/// Облачный пароль по OPAQUE-3DH (RFC 9807): на сервер не уходит ни пароль, ни
/// что-либо ему равноценное. Конфигурация общая с сервером
/// (`internal/crypto/opaque.go` в iperon) и **неизменна навсегда**: другой
/// context или параметры KSF — и все установленные пароли перестанут подходить.
const cloudPasswordContext = 'iperon-cloud-password-v1';

/// KSF — Argon2id, 64 MiB, 3 прохода, 4 потока: замедляет офлайн-перебор, если
/// утекут и база, и ключ сервера.
const cloudPasswordKsf = OpaqueKsf.argon2id(iterations: 3, memory: 64 * 1024, parallelism: 4);

/// Клиент OPAQUE облачного пароля (новый на каждый обмен).
OpaqueClient cloudPasswordClient() => OpaqueClient(context: Uint8List.fromList(utf8.encode(cloudPasswordContext)), ksf: cloudPasswordKsf);

/// Пароль байтами для OPAQUE.
Uint8List cloudPasswordBytes(String password) => Uint8List.fromList(utf8.encode(password));
