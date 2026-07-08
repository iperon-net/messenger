// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_two_step_verification_state.dart';

class SettingsTwoStepVerificationStateMapper
    extends ClassMapperBase<SettingsTwoStepVerificationState> {
  SettingsTwoStepVerificationStateMapper._();

  static SettingsTwoStepVerificationStateMapper? _instance;
  static SettingsTwoStepVerificationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsTwoStepVerificationStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsTwoStepVerificationState';

  static Status _$status(SettingsTwoStepVerificationState v) => v.status;
  static const Field<SettingsTwoStepVerificationState, Status> _f$status =
      Field('status', _$status, opt: true, def: Status.initialization);
  static bool _$nextButton(SettingsTwoStepVerificationState v) => v.nextButton;
  static const Field<SettingsTwoStepVerificationState, bool> _f$nextButton =
      Field('nextButton', _$nextButton, opt: true, def: false);
  static String _$password(SettingsTwoStepVerificationState v) => v.password;
  static const Field<SettingsTwoStepVerificationState, String> _f$password =
      Field('password', _$password, opt: true, def: "");
  static String _$email(SettingsTwoStepVerificationState v) => v.email;
  static const Field<SettingsTwoStepVerificationState, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
    def: "",
  );
  static String _$redirectUrl(SettingsTwoStepVerificationState v) =>
      v.redirectUrl;
  static const Field<SettingsTwoStepVerificationState, String> _f$redirectUrl =
      Field('redirectUrl', _$redirectUrl, opt: true, def: "");

  @override
  final MappableFields<SettingsTwoStepVerificationState> fields = const {
    #status: _f$status,
    #nextButton: _f$nextButton,
    #password: _f$password,
    #email: _f$email,
    #redirectUrl: _f$redirectUrl,
  };

  static SettingsTwoStepVerificationState _instantiate(DecodingData data) {
    return SettingsTwoStepVerificationState(
      status: data.dec(_f$status),
      nextButton: data.dec(_f$nextButton),
      password: data.dec(_f$password),
      email: data.dec(_f$email),
      redirectUrl: data.dec(_f$redirectUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsTwoStepVerificationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsTwoStepVerificationState>(map);
  }

  static SettingsTwoStepVerificationState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsTwoStepVerificationState>(
      json,
    );
  }
}

mixin SettingsTwoStepVerificationStateMappable {
  String toJson() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .encodeJson<SettingsTwoStepVerificationState>(
          this as SettingsTwoStepVerificationState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .encodeMap<SettingsTwoStepVerificationState>(
          this as SettingsTwoStepVerificationState,
        );
  }

  SettingsTwoStepVerificationStateCopyWith<
    SettingsTwoStepVerificationState,
    SettingsTwoStepVerificationState,
    SettingsTwoStepVerificationState
  >
  get copyWith =>
      _SettingsTwoStepVerificationStateCopyWithImpl<
        SettingsTwoStepVerificationState,
        SettingsTwoStepVerificationState
      >(this as SettingsTwoStepVerificationState, $identity, $identity);
  @override
  String toString() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsTwoStepVerificationState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .equalsValue(this as SettingsTwoStepVerificationState, other);
  }

  @override
  int get hashCode {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized().hashValue(
      this as SettingsTwoStepVerificationState,
    );
  }
}

extension SettingsTwoStepVerificationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsTwoStepVerificationState, $Out> {
  SettingsTwoStepVerificationStateCopyWith<
    $R,
    SettingsTwoStepVerificationState,
    $Out
  >
  get $asSettingsTwoStepVerificationState => $base.as(
    (v, t, t2) =>
        _SettingsTwoStepVerificationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsTwoStepVerificationStateCopyWith<
  $R,
  $In extends SettingsTwoStepVerificationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    bool? nextButton,
    String? password,
    String? email,
    String? redirectUrl,
  });
  SettingsTwoStepVerificationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsTwoStepVerificationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsTwoStepVerificationState, $Out>
    implements
        SettingsTwoStepVerificationStateCopyWith<
          $R,
          SettingsTwoStepVerificationState,
          $Out
        > {
  _SettingsTwoStepVerificationStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsTwoStepVerificationState> $mapper =
      SettingsTwoStepVerificationStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    bool? nextButton,
    String? password,
    String? email,
    String? redirectUrl,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (nextButton != null) #nextButton: nextButton,
      if (password != null) #password: password,
      if (email != null) #email: email,
      if (redirectUrl != null) #redirectUrl: redirectUrl,
    }),
  );
  @override
  SettingsTwoStepVerificationState $make(CopyWithData data) =>
      SettingsTwoStepVerificationState(
        status: data.get(#status, or: $value.status),
        nextButton: data.get(#nextButton, or: $value.nextButton),
        password: data.get(#password, or: $value.password),
        email: data.get(#email, or: $value.email),
        redirectUrl: data.get(#redirectUrl, or: $value.redirectUrl),
      );

  @override
  SettingsTwoStepVerificationStateCopyWith<
    $R2,
    SettingsTwoStepVerificationState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsTwoStepVerificationStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

