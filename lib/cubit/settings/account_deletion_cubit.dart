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

  const AccountDeletionState({this.manualDeleteAfter, this.autoDeleteAfter, this.loading = false, this.loaded = false});

  AccountDeletionState copyWith({
    DateTime? manualDeleteAfter,
    DateTime? autoDeleteAfter,
    bool? loading,
    bool? loaded,
    bool clearManual = false,
  }) {
    return AccountDeletionState(
      manualDeleteAfter: clearManual ? null : manualDeleteAfter ?? this.manualDeleteAfter,
      autoDeleteAfter: autoDeleteAfter ?? this.autoDeleteAfter,
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
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
    emit(
      AccountDeletionState(
        manualDeleteAfter: response.hasManualDeleteAfter() ? response.manualDeleteAfter.toDateTime() : null,
        autoDeleteAfter: response.hasAutoDeleteAfter() ? response.autoDeleteAfter.toDateTime() : null,
        loaded: true,
      ),
    );
  }

  Future<bool> request(String phone, String password) async {
    if (!await utils.hasNetwork()) return false;
    emit(state.copyWith(loading: true));
    List<int> token = const [];
    if (password.isNotEmpty) {
      final unlocked = await CloudPassword.unlock(api, password);
      if (unlocked.error.isNotEmpty) {
        if (!isClosed) emit(state.copyWith(loading: false));
        return false;
      }
      token = unlocked.token;
    }
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.ACCOUNT_DELETION_REQUEST,
      AccountDeletionRequest_Request(phoneNumber: phone, cloudPasswordToken: token).writeToBuffer(),
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
