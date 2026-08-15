// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'phone_number.dart';

class PhoneNumberModelMapper extends ClassMapperBase<PhoneNumberModel> {
  PhoneNumberModelMapper._();

  static PhoneNumberModelMapper? _instance;
  static PhoneNumberModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhoneNumberModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PhoneNumberModel';

  static String _$international(PhoneNumberModel v) => v.international;
  static const Field<PhoneNumberModel, String> _f$international = Field(
    'international',
    _$international,
  );
  static String _$national(PhoneNumberModel v) => v.national;
  static const Field<PhoneNumberModel, String> _f$national = Field(
    'national',
    _$national,
  );
  static String _$e164(PhoneNumberModel v) => v.e164;
  static const Field<PhoneNumberModel, String> _f$e164 = Field('e164', _$e164);
  static String _$rfc3966(PhoneNumberModel v) => v.rfc3966;
  static const Field<PhoneNumberModel, String> _f$rfc3966 = Field(
    'rfc3966',
    _$rfc3966,
  );
  static String _$raw(PhoneNumberModel v) => v.raw;
  static const Field<PhoneNumberModel, String> _f$raw = Field('raw', _$raw);

  @override
  final MappableFields<PhoneNumberModel> fields = const {
    #international: _f$international,
    #national: _f$national,
    #e164: _f$e164,
    #rfc3966: _f$rfc3966,
    #raw: _f$raw,
  };

  static PhoneNumberModel _instantiate(DecodingData data) {
    return PhoneNumberModel(
      international: data.dec(_f$international),
      national: data.dec(_f$national),
      e164: data.dec(_f$e164),
      rfc3966: data.dec(_f$rfc3966),
      raw: data.dec(_f$raw),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhoneNumberModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhoneNumberModel>(map);
  }

  static PhoneNumberModel fromJson(String json) {
    return ensureInitialized().decodeJson<PhoneNumberModel>(json);
  }
}

mixin PhoneNumberModelMappable {
  String toJson() {
    return PhoneNumberModelMapper.ensureInitialized()
        .encodeJson<PhoneNumberModel>(this as PhoneNumberModel);
  }

  Map<String, dynamic> toMap() {
    return PhoneNumberModelMapper.ensureInitialized()
        .encodeMap<PhoneNumberModel>(this as PhoneNumberModel);
  }

  PhoneNumberModelCopyWith<PhoneNumberModel, PhoneNumberModel, PhoneNumberModel>
  get copyWith =>
      _PhoneNumberModelCopyWithImpl<PhoneNumberModel, PhoneNumberModel>(
        this as PhoneNumberModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhoneNumberModelMapper.ensureInitialized().stringifyValue(
      this as PhoneNumberModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhoneNumberModelMapper.ensureInitialized().equalsValue(
      this as PhoneNumberModel,
      other,
    );
  }

  @override
  int get hashCode {
    return PhoneNumberModelMapper.ensureInitialized().hashValue(
      this as PhoneNumberModel,
    );
  }
}

extension PhoneNumberModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhoneNumberModel, $Out> {
  PhoneNumberModelCopyWith<$R, PhoneNumberModel, $Out>
  get $asPhoneNumberModel =>
      $base.as((v, t, t2) => _PhoneNumberModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhoneNumberModelCopyWith<$R, $In extends PhoneNumberModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? international,
    String? national,
    String? e164,
    String? rfc3966,
    String? raw,
  });
  PhoneNumberModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhoneNumberModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhoneNumberModel, $Out>
    implements PhoneNumberModelCopyWith<$R, PhoneNumberModel, $Out> {
  _PhoneNumberModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhoneNumberModel> $mapper =
      PhoneNumberModelMapper.ensureInitialized();
  @override
  $R call({
    String? international,
    String? national,
    String? e164,
    String? rfc3966,
    String? raw,
  }) => $apply(
    FieldCopyWithData({
      if (international != null) #international: international,
      if (national != null) #national: national,
      if (e164 != null) #e164: e164,
      if (rfc3966 != null) #rfc3966: rfc3966,
      if (raw != null) #raw: raw,
    }),
  );
  @override
  PhoneNumberModel $make(CopyWithData data) => PhoneNumberModel(
    international: data.get(#international, or: $value.international),
    national: data.get(#national, or: $value.national),
    e164: data.get(#e164, or: $value.e164),
    rfc3966: data.get(#rfc3966, or: $value.rfc3966),
    raw: data.get(#raw, or: $value.raw),
  );

  @override
  PhoneNumberModelCopyWith<$R2, PhoneNumberModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhoneNumberModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

