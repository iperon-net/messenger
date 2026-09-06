// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cdn.dart';

class CDNMapper extends ClassMapperBase<CDN> {
  CDNMapper._();

  static CDNMapper? _instance;
  static CDNMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CDNMapper._());
      MapperContainer.globals.useAll([
        Uint8ListMapper(),
        EpochDateTimeMapper(),
      ]);
    }
    return _instance!;
  }

  @override
  final String id = 'CDN';

  static Uint8List _$cdnID(CDN v) => v.cdnID;
  static const Field<CDN, Uint8List> _f$cdnID = Field('cdnID', _$cdnID);
  static String _$url(CDN v) => v.url;
  static const Field<CDN, String> _f$url = Field('url', _$url);
  static Uint8List _$hashSumEncrypted(CDN v) => v.hashSumEncrypted;
  static const Field<CDN, Uint8List> _f$hashSumEncrypted = Field(
    'hashSumEncrypted',
    _$hashSumEncrypted,
  );
  static String _$contentType(CDN v) => v.contentType;
  static const Field<CDN, String> _f$contentType = Field(
    'contentType',
    _$contentType,
  );
  static Uint8List _$encryptionKey(CDN v) => v.encryptionKey;
  static const Field<CDN, Uint8List> _f$encryptionKey = Field(
    'encryptionKey',
    _$encryptionKey,
  );
  static Uint8List _$hkdfSalt(CDN v) => v.hkdfSalt;
  static const Field<CDN, Uint8List> _f$hkdfSalt = Field(
    'hkdfSalt',
    _$hkdfSalt,
  );
  static DateTime _$createAt(CDN v) => v.createAt;
  static const Field<CDN, DateTime> _f$createAt = Field('createAt', _$createAt);

  @override
  final MappableFields<CDN> fields = const {
    #cdnID: _f$cdnID,
    #url: _f$url,
    #hashSumEncrypted: _f$hashSumEncrypted,
    #contentType: _f$contentType,
    #encryptionKey: _f$encryptionKey,
    #hkdfSalt: _f$hkdfSalt,
    #createAt: _f$createAt,
  };

  static CDN _instantiate(DecodingData data) {
    return CDN(
      cdnID: data.dec(_f$cdnID),
      url: data.dec(_f$url),
      hashSumEncrypted: data.dec(_f$hashSumEncrypted),
      contentType: data.dec(_f$contentType),
      encryptionKey: data.dec(_f$encryptionKey),
      hkdfSalt: data.dec(_f$hkdfSalt),
      createAt: data.dec(_f$createAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CDN fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CDN>(map);
  }

  static CDN fromJson(String json) {
    return ensureInitialized().decodeJson<CDN>(json);
  }
}

mixin CDNMappable {
  String toJson() {
    return CDNMapper.ensureInitialized().encodeJson<CDN>(this as CDN);
  }

  Map<String, dynamic> toMap() {
    return CDNMapper.ensureInitialized().encodeMap<CDN>(this as CDN);
  }

  CDNCopyWith<CDN, CDN, CDN> get copyWith =>
      _CDNCopyWithImpl<CDN, CDN>(this as CDN, $identity, $identity);
  @override
  String toString() {
    return CDNMapper.ensureInitialized().stringifyValue(this as CDN);
  }

  @override
  bool operator ==(Object other) {
    return CDNMapper.ensureInitialized().equalsValue(this as CDN, other);
  }

  @override
  int get hashCode {
    return CDNMapper.ensureInitialized().hashValue(this as CDN);
  }
}

extension CDNValueCopy<$R, $Out> on ObjectCopyWith<$R, CDN, $Out> {
  CDNCopyWith<$R, CDN, $Out> get $asCDN =>
      $base.as((v, t, t2) => _CDNCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CDNCopyWith<$R, $In extends CDN, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Uint8List? cdnID,
    String? url,
    Uint8List? hashSumEncrypted,
    String? contentType,
    Uint8List? encryptionKey,
    Uint8List? hkdfSalt,
    DateTime? createAt,
  });
  CDNCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CDNCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, CDN, $Out>
    implements CDNCopyWith<$R, CDN, $Out> {
  _CDNCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CDN> $mapper = CDNMapper.ensureInitialized();
  @override
  $R call({
    Uint8List? cdnID,
    String? url,
    Uint8List? hashSumEncrypted,
    String? contentType,
    Uint8List? encryptionKey,
    Uint8List? hkdfSalt,
    DateTime? createAt,
  }) => $apply(
    FieldCopyWithData({
      if (cdnID != null) #cdnID: cdnID,
      if (url != null) #url: url,
      if (hashSumEncrypted != null) #hashSumEncrypted: hashSumEncrypted,
      if (contentType != null) #contentType: contentType,
      if (encryptionKey != null) #encryptionKey: encryptionKey,
      if (hkdfSalt != null) #hkdfSalt: hkdfSalt,
      if (createAt != null) #createAt: createAt,
    }),
  );
  @override
  CDN $make(CopyWithData data) => CDN(
    cdnID: data.get(#cdnID, or: $value.cdnID),
    url: data.get(#url, or: $value.url),
    hashSumEncrypted: data.get(#hashSumEncrypted, or: $value.hashSumEncrypted),
    contentType: data.get(#contentType, or: $value.contentType),
    encryptionKey: data.get(#encryptionKey, or: $value.encryptionKey),
    hkdfSalt: data.get(#hkdfSalt, or: $value.hkdfSalt),
    createAt: data.get(#createAt, or: $value.createAt),
  );

  @override
  CDNCopyWith<$R2, CDN, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CDNCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

