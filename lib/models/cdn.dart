import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../protobuf.dart' as pb;
import 'mapper.dart';

part 'cdn.mapper.dart';

/// Доменная модель загруженного на CDN файла — то, что [CDNManager] отдаёт
/// наружу после успешного `UPLOAD_CONFIRM`. Сознательно отвязана от protobuf
/// `CDN`: вызывающий код (cubit'ы, репозитории) работает с обычной
/// dart_mappable-моделью (copyWith/equality), а не с `GeneratedMessage`.
@MappableClass(includeCustomMappers: [Uint8ListMapper(), EpochDateTimeMapper()])
class CDN with CDNMappable {
  final Uint8List cdnID;
  final String url;
  final Uint8List hashSumEncrypted;
  final String contentType;
  final Uint8List encryptionKey;
  final Uint8List hkdfSalt;
  final DateTime createAt;

  const CDN({
    required this.cdnID,
    required this.url,
    required this.hashSumEncrypted,
    required this.contentType,
    required this.encryptionKey,
    required this.hkdfSalt,
    required this.createAt,
  });

  factory CDN.fromProto(pb.CDN proto) => CDN(
    cdnID: Uint8List.fromList(proto.cdnID),
    url: proto.url,
    hashSumEncrypted: Uint8List.fromList(proto.hashSumEncrypted),
    contentType: proto.contentType,
    encryptionKey: Uint8List.fromList(proto.encryptionKey),
    hkdfSalt: Uint8List.fromList(proto.hkdfSalt),
    createAt: proto.createAt.toDateTime(),
  );
}
