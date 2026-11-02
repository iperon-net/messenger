// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'emoji_status.dart';

class EmojiStatusMapper extends ClassMapperBase<EmojiStatus> {
  EmojiStatusMapper._();

  static EmojiStatusMapper? _instance;
  static EmojiStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EmojiStatusMapper._());
      MapperContainer.globals.useAll([EpochDateTimeMapper(), BoolMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'EmojiStatus';

  static String _$emoji(EmojiStatus v) => v.emoji;
  static const Field<EmojiStatus, String> _f$emoji = Field(
    'emoji',
    _$emoji,
    opt: true,
    def: '',
  );
  static DateTime? _$expiresAt(EmojiStatus v) => v.expiresAt;
  static const Field<EmojiStatus, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
    opt: true,
  );
  static bool _$doNotDisturb(EmojiStatus v) => v.doNotDisturb;
  static const Field<EmojiStatus, bool> _f$doNotDisturb = Field(
    'doNotDisturb',
    _$doNotDisturb,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<EmojiStatus> fields = const {
    #emoji: _f$emoji,
    #expiresAt: _f$expiresAt,
    #doNotDisturb: _f$doNotDisturb,
  };

  static EmojiStatus _instantiate(DecodingData data) {
    return EmojiStatus(
      emoji: data.dec(_f$emoji),
      expiresAt: data.dec(_f$expiresAt),
      doNotDisturb: data.dec(_f$doNotDisturb),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EmojiStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EmojiStatus>(map);
  }

  static EmojiStatus fromJson(String json) {
    return ensureInitialized().decodeJson<EmojiStatus>(json);
  }
}

mixin EmojiStatusMappable {
  String toJson() {
    return EmojiStatusMapper.ensureInitialized().encodeJson<EmojiStatus>(
      this as EmojiStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return EmojiStatusMapper.ensureInitialized().encodeMap<EmojiStatus>(
      this as EmojiStatus,
    );
  }

  EmojiStatusCopyWith<EmojiStatus, EmojiStatus, EmojiStatus> get copyWith =>
      _EmojiStatusCopyWithImpl<EmojiStatus, EmojiStatus>(
        this as EmojiStatus,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EmojiStatusMapper.ensureInitialized().stringifyValue(
      this as EmojiStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return EmojiStatusMapper.ensureInitialized().equalsValue(
      this as EmojiStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return EmojiStatusMapper.ensureInitialized().hashValue(this as EmojiStatus);
  }
}

extension EmojiStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EmojiStatus, $Out> {
  EmojiStatusCopyWith<$R, EmojiStatus, $Out> get $asEmojiStatus =>
      $base.as((v, t, t2) => _EmojiStatusCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EmojiStatusCopyWith<$R, $In extends EmojiStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? emoji, DateTime? expiresAt, bool? doNotDisturb});
  EmojiStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EmojiStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EmojiStatus, $Out>
    implements EmojiStatusCopyWith<$R, EmojiStatus, $Out> {
  _EmojiStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EmojiStatus> $mapper =
      EmojiStatusMapper.ensureInitialized();
  @override
  $R call({String? emoji, Object? expiresAt = $none, bool? doNotDisturb}) =>
      $apply(
        FieldCopyWithData({
          if (emoji != null) #emoji: emoji,
          if (expiresAt != $none) #expiresAt: expiresAt,
          if (doNotDisturb != null) #doNotDisturb: doNotDisturb,
        }),
      );
  @override
  EmojiStatus $make(CopyWithData data) => EmojiStatus(
    emoji: data.get(#emoji, or: $value.emoji),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    doNotDisturb: data.get(#doNotDisturb, or: $value.doNotDisturb),
  );

  @override
  EmojiStatusCopyWith<$R2, EmojiStatus, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EmojiStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

