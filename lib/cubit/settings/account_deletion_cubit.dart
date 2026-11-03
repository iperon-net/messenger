import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../cloud_password.dart';
import '../../di.dart';
import '../../protobuf.dart';
import '../../utils.dart';

class AccountDeletionState {
  final DateTime? manualDeleteAfter;
  final DateTime? autoDeleteAfter;
  final bool loading;
  final bool loaded;
  final bool cloudPasswordEnabled;
  final bool cloudPasswordUnlocked;
  final List<int> cloudPasswordToken;
  final String error;

  const AccountDeletionState({
    this.manualDeleteAfter,
    this.autoDeleteAfter,
    this.loading = false,
    this.loaded = false,
    this.cloudPasswordEnabled = false,
    this.cloudPasswordUnlocked = false,
    this.cloudPasswordToken = const [],
    this.error = '',
  });

  AccountDeletionState copyWith({
    DateTime? manualDeleteAfter,
    DateTime? autoDeleteAfter,
    bool? loading,
    bool? loaded,
    bool? cloudPasswordEnabled,
    bool? cloudPasswordUnlocked,
    List<int>? cloudPasswordToken,
    String? error,
    bool clearManual = false,
  }) {
    return AccountDeletionState(
      manualDeleteAfter: clearManual ? null : manualDeleteAfter ?? this.manualDeleteAfter,
      autoDeleteAfter: autoDeleteAfter ?? this.autoDeleteAfter,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      cloudPasswordEnabled: cloudPasswordEnabled ?? this.cloudPasswordEnabled,
      cloudPasswordUnlocked: cloudPasswordUnlocked ?? this.cloudPasswordUnlocked,
      cloudPasswordToken: cloudPasswordToken ?? this.cloudPasswordToken,
      error: error ?? this.error,
    );
  }
}

class AccountDeletionCubit extends Cubit<AccountDeletionState> {
  AccountDeletionCubit() : super(const AccountDeletionState());

  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();

  Future<void> load() async {
    if (!await utils.hasNetwork()) return;
    emit(state.copyWith(loading: true));
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.ACCOUNT_DELETION_STATUS,
      AccountDeletionStatus_Request().writeToBuffer(),
    );
    if (isClosed) return;
    if (status.status != APIStatus.success || payload == null) {
      emit(state.copyWith(loading: false));
      return;
    }
    final response = AccountDeletionStatus_Response.fromBuffer(payload);
    final (passwordStatus, passwordPayload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_INFO,
      CloudPasswordInfo_Request().writeToBuffer(),
    );
    if (isClosed) return;
    if (passwordStatus.status != APIStatus.success || passwordPayload == null) {
      emit(state.copyWith(loading: false));
      return;
    }
    final passwordInfo = CloudPasswordInfo_Response.fromBuffer(passwordPayload);
    emit(
      AccountDeletionState(
        manualDeleteAfter: response.hasManualDeleteAfter() ? response.manualDeleteAfter.toDateTime() : null,
        autoDeleteAfter: response.hasAutoDeleteAfter() ? response.autoDeleteAfter.toDateTime() : null,
        cloudPasswordEnabled: passwordInfo.isEnabled,
        loaded: true,
      ),
    );
  }

  Future<bool> unlock(String password) async {
    if (password.isEmpty) {
      emit(state.copyWith(error: 'cloudPassword.passwordRequired'));
      return false;
    }
    if (!await utils.hasNetwork()) return false;
    emit(state.copyWith(loading: true, error: ''));
    final unlocked = await CloudPassword.unlock(api, password);
    if (isClosed) return false;
    if (unlocked.error.isNotEmpty) {
      emit(state.copyWith(loading: false, error: unlocked.error));
      return false;
    }
    emit(state.copyWith(loading: false, cloudPasswordUnlocked: true, cloudPasswordToken: unlocked.token, error: ''));
    return true;
  }

  Future<bool> request(String phone) async {
    if (!await utils.hasNetwork()) return false;
    emit(state.copyWith(loading: true, error: ''));
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.ACCOUNT_DELETION_REQUEST,
      AccountDeletionRequest_Request(phoneNumber: phone, cloudPasswordToken: state.cloudPasswordToken).writeToBuffer(),
    );
    if (isClosed) return false;
    if (status.status != APIStatus.success || payload == null) {
      emit(state.copyWith(loading: false));
      return false;
    }
    final response = AccountDeletionRequest_Response.fromBuffer(payload);
    emit(state.copyWith(manualDeleteAfter: response.manualDeleteAfter.toDateTime(), loading: false, loaded: true));
    return true;
  }

  Future<bool> cancel() async {
    if (!await utils.hasNetwork()) return false;
    final status = await api.unaryEncoded(MessageType.ACCOUNT_DELETION_CANCEL, AccountDeletionCancel_Request().writeToBuffer());
    if (status.status != APIStatus.success) return false;
    if (!isClosed) emit(state.copyWith(clearManual: true, loaded: true));
    return true;
  }

  Future<bool> keepAccount() async {
    if (!await utils.hasNetwork()) return false;
    final status = await api.unaryEncoded(MessageType.ACCOUNT_ACTIVITY, AccountActivity_Request().writeToBuffer());
    return status.status == APIStatus.success;
  }
}
