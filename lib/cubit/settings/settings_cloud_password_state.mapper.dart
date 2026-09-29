// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_cloud_password_state.dart';

class SettingsCloudPasswordStateMapper
    extends ClassMapperBase<SettingsCloudPasswordState> {
  SettingsCloudPasswordStateMapper._();

  static SettingsCloudPasswordStateMapper? _instance;
  static SettingsCloudPasswordStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsCloudPasswordStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsCloudPasswordState';

  static SettingsCloudPasswordStep _$step(SettingsCloudPasswordState v) =>
      v.step;
  static const Field<SettingsCloudPasswordState, SettingsCloudPasswordStep>
  _f$step = Field(
    'step',
    _$step,
    opt: true,
    def: SettingsCloudPasswordStep.loading,
  );
  static Status _$networkStatus(SettingsCloudPasswordState v) =>
      v.networkStatus;
  static const Field<SettingsCloudPasswordState, Status> _f$networkStatus =
      Field(
        'networkStatus',
        _$networkStatus,
        opt: true,
        def: Status.initialization,
      );
  static bool _$loadError(SettingsCloudPasswordState v) => v.loadError;
  static const Field<SettingsCloudPasswordState, bool> _f$loadError = Field(
    'loadError',
    _$loadError,
    opt: true,
    def: false,
  );
  static bool _$isEnabled(SettingsCloudPasswordState v) => v.isEnabled;
  static const Field<SettingsCloudPasswordState, bool> _f$isEnabled = Field(
    'isEnabled',
    _$isEnabled,
    opt: true,
    def: false,
  );
  static String _$maskedEmail(SettingsCloudPasswordState v) => v.maskedEmail;
  static const Field<SettingsCloudPasswordState, String> _f$maskedEmail = Field(
    'maskedEmail',
    _$maskedEmail,
    opt: true,
    def: "",
  );
  static bool _$isEmailVerified(SettingsCloudPasswordState v) =>
      v.isEmailVerified;
  static const Field<SettingsCloudPasswordState, bool> _f$isEmailVerified =
      Field('isEmailVerified', _$isEmailVerified, opt: true, def: false);
  static String _$error(SettingsCloudPasswordState v) => v.error;
  static const Field<SettingsCloudPasswordState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static List<int> _$heldPwHash(SettingsCloudPasswordState v) => v.heldPwHash;
  static const Field<SettingsCloudPasswordState, List<int>> _f$heldPwHash =
      Field('heldPwHash', _$heldPwHash, opt: true, def: const []);
  static String _$pendingEmail(SettingsCloudPasswordState v) => v.pendingEmail;
  static const Field<SettingsCloudPasswordState, String> _f$pendingEmail =
      Field('pendingEmail', _$pendingEmail, opt: true, def: "");

  @override
  final MappableFields<SettingsCloudPasswordState> fields = const {
    #step: _f$step,
    #networkStatus: _f$networkStatus,
    #loadError: _f$loadError,
    #isEnabled: _f$isEnabled,
    #maskedEmail: _f$maskedEmail,
    #isEmailVerified: _f$isEmailVerified,
    #error: _f$error,
    #heldPwHash: _f$heldPwHash,
    #pendingEmail: _f$pendingEmail,
  };

  static SettingsCloudPasswordState _instantiate(DecodingData data) {
    return SettingsCloudPasswordState(
      step: data.dec(_f$step),
      networkStatus: data.dec(_f$networkStatus),
      loadError: data.dec(_f$loadError),
      isEnabled: data.dec(_f$isEnabled),
      maskedEmail: data.dec(_f$maskedEmail),
      isEmailVerified: data.dec(_f$isEmailVerified),
      error: data.dec(_f$error),
      heldPwHash: data.dec(_f$heldPwHash),
      pendingEmail: data.dec(_f$pendingEmail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsCloudPasswordState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsCloudPasswordState>(map);
  }

  static SettingsCloudPasswordState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsCloudPasswordState>(json);
  }
}

mixin SettingsCloudPasswordStateMappable {
  String toJson() {
    return SettingsCloudPasswordStateMapper.ensureInitialized()
        .encodeJson<SettingsCloudPasswordState>(
          this as SettingsCloudPasswordState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsCloudPasswordStateMapper.ensureInitialized()
        .encodeMap<SettingsCloudPasswordState>(
          this as SettingsCloudPasswordState,
        );
  }

  SettingsCloudPasswordStateCopyWith<
    SettingsCloudPasswordState,
    SettingsCloudPasswordState,
    SettingsCloudPasswordState
  >
  get copyWith =>
      _SettingsCloudPasswordStateCopyWithImpl<
        SettingsCloudPasswordState,
        SettingsCloudPasswordState
      >(this as SettingsCloudPasswordState, $identity, $identity);
  @override
  String toString() {
    return SettingsCloudPasswordStateMapper.ensureInitialized().stringifyValue(
      this as SettingsCloudPasswordState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsCloudPasswordStateMapper.ensureInitialized().equalsValue(
      this as SettingsCloudPasswordState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsCloudPasswordStateMapper.ensureInitialized().hashValue(
      this as SettingsCloudPasswordState,
    );
  }
}

extension SettingsCloudPasswordStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsCloudPasswordState, $Out> {
  SettingsCloudPasswordStateCopyWith<$R, SettingsCloudPasswordState, $Out>
  get $asSettingsCloudPasswordState => $base.as(
    (v, t, t2) => _SettingsCloudPasswordStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsCloudPasswordStateCopyWith<
  $R,
  $In extends SettingsCloudPasswordState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get heldPwHash;
  $R call({
    SettingsCloudPasswordStep? step,
    Status? networkStatus,
    bool? loadError,
    bool? isEnabled,
    String? maskedEmail,
    bool? isEmailVerified,
    String? error,
    List<int>? heldPwHash,
    String? pendingEmail,
  });
  SettingsCloudPasswordStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsCloudPasswordStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsCloudPasswordState, $Out>
    implements
        SettingsCloudPasswordStateCopyWith<
          $R,
          SettingsCloudPasswordState,
          $Out
        > {
  _SettingsCloudPasswordStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsCloudPasswordState> $mapper =
      SettingsCloudPasswordStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get heldPwHash =>
      ListCopyWith(
        $value.heldPwHash,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(heldPwHash: v),
      );
  @override
  $R call({
    SettingsCloudPasswordStep? step,
    Status? networkStatus,
    bool? loadError,
    bool? isEnabled,
    String? maskedEmail,
    bool? isEmailVerified,
    String? error,
    List<int>? heldPwHash,
    String? pendingEmail,
  }) => $apply(
    FieldCopyWithData({
      if (step != null) #step: step,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (loadError != null) #loadError: loadError,
      if (isEnabled != null) #isEnabled: isEnabled,
      if (maskedEmail != null) #maskedEmail: maskedEmail,
      if (isEmailVerified != null) #isEmailVerified: isEmailVerified,
      if (error != null) #error: error,
      if (heldPwHash != null) #heldPwHash: heldPwHash,
      if (pendingEmail != null) #pendingEmail: pendingEmail,
    }),
  );
  @override
  SettingsCloudPasswordState $make(CopyWithData data) =>
      SettingsCloudPasswordState(
        step: data.get(#step, or: $value.step),
        networkStatus: data.get(#networkStatus, or: $value.networkStatus),
        loadError: data.get(#loadError, or: $value.loadError),
        isEnabled: data.get(#isEnabled, or: $value.isEnabled),
        maskedEmail: data.get(#maskedEmail, or: $value.maskedEmail),
        isEmailVerified: data.get(#isEmailVerified, or: $value.isEmailVerified),
        error: data.get(#error, or: $value.error),
        heldPwHash: data.get(#heldPwHash, or: $value.heldPwHash),
        pendingEmail: data.get(#pendingEmail, or: $value.pendingEmail),
      );

  @override
  SettingsCloudPasswordStateCopyWith<$R2, SettingsCloudPasswordState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsCloudPasswordStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

