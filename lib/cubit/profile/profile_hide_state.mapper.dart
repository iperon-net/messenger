// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile_hide_state.dart';

class ProfileHideStateMapper extends ClassMapperBase<ProfileHideState> {
  ProfileHideStateMapper._();

  static ProfileHideStateMapper? _instance;
  static ProfileHideStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileHideStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProfileHideState';

  static Status _$status(ProfileHideState v) => v.status;
  static const Field<ProfileHideState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static bool _$isHidden(ProfileHideState v) => v.isHidden;
  static const Field<ProfileHideState, bool> _f$isHidden = Field(
    'isHidden',
    _$isHidden,
    opt: true,
    def: false,
  );
  static String _$error(ProfileHideState v) => v.error;
  static const Field<ProfileHideState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static bool _$saved(ProfileHideState v) => v.saved;
  static const Field<ProfileHideState, bool> _f$saved = Field(
    'saved',
    _$saved,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ProfileHideState> fields = const {
    #status: _f$status,
    #isHidden: _f$isHidden,
    #error: _f$error,
    #saved: _f$saved,
  };

  static ProfileHideState _instantiate(DecodingData data) {
    return ProfileHideState(
      status: data.dec(_f$status),
      isHidden: data.dec(_f$isHidden),
      error: data.dec(_f$error),
      saved: data.dec(_f$saved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProfileHideState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProfileHideState>(map);
  }

  static ProfileHideState fromJson(String json) {
    return ensureInitialized().decodeJson<ProfileHideState>(json);
  }
}

mixin ProfileHideStateMappable {
  String toJson() {
    return ProfileHideStateMapper.ensureInitialized()
        .encodeJson<ProfileHideState>(this as ProfileHideState);
  }

  Map<String, dynamic> toMap() {
    return ProfileHideStateMapper.ensureInitialized()
        .encodeMap<ProfileHideState>(this as ProfileHideState);
  }

  ProfileHideStateCopyWith<ProfileHideState, ProfileHideState, ProfileHideState>
  get copyWith =>
      _ProfileHideStateCopyWithImpl<ProfileHideState, ProfileHideState>(
        this as ProfileHideState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProfileHideStateMapper.ensureInitialized().stringifyValue(
      this as ProfileHideState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProfileHideStateMapper.ensureInitialized().equalsValue(
      this as ProfileHideState,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileHideStateMapper.ensureInitialized().hashValue(
      this as ProfileHideState,
    );
  }
}

extension ProfileHideStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProfileHideState, $Out> {
  ProfileHideStateCopyWith<$R, ProfileHideState, $Out>
  get $asProfileHideState =>
      $base.as((v, t, t2) => _ProfileHideStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileHideStateCopyWith<$R, $In extends ProfileHideState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, bool? isHidden, String? error, bool? saved});
  ProfileHideStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProfileHideStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProfileHideState, $Out>
    implements ProfileHideStateCopyWith<$R, ProfileHideState, $Out> {
  _ProfileHideStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProfileHideState> $mapper =
      ProfileHideStateMapper.ensureInitialized();
  @override
  $R call({Status? status, bool? isHidden, String? error, bool? saved}) =>
      $apply(
        FieldCopyWithData({
          if (status != null) #status: status,
          if (isHidden != null) #isHidden: isHidden,
          if (error != null) #error: error,
          if (saved != null) #saved: saved,
        }),
      );
  @override
  ProfileHideState $make(CopyWithData data) => ProfileHideState(
    status: data.get(#status, or: $value.status),
    isHidden: data.get(#isHidden, or: $value.isHidden),
    error: data.get(#error, or: $value.error),
    saved: data.get(#saved, or: $value.saved),
  );

  @override
  ProfileHideStateCopyWith<$R2, ProfileHideState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProfileHideStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

