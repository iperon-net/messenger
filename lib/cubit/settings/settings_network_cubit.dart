import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../network_usage.dart';
import 'settings_network_state.dart';

/// «Использование трафика»: счётчики по мобильной сети и Wi-Fi (локальные,
/// сеть не нужна), обновляются вживую, пока экран открыт.
class SettingsNetworkCubit extends Cubit<SettingsNetworkState> {
  SettingsNetworkCubit() : super(const SettingsNetworkState());

  final logger = getIt.get<Logger>();
  final usage = NetworkUsage.instance;

  StreamSubscription<void>? _changes;

  /// Пока экран открыт — дописывать накопленное чаще обычного.
  Timer? _flush;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    _changes = usage.changed.listen((_) => _load());
    _flush = Timer.periodic(const Duration(seconds: 3), (_) => usage.flush());
    await _load();
  }

  Future<void> _load() async {
    try {
      final traffic = await usage.load();
      final since = await usage.since();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: Status.success,
          mobile: {
            for (final MapEntry(key: (network, category), :value) in traffic.entries)
              if (network == models.NetworkKind.mobile) category: value,
          },
          wifi: {
            for (final MapEntry(key: (network, category), :value) in traffic.entries)
              if (network == models.NetworkKind.wifi) category: value,
          },
          since: since,
        ),
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success));
    }
  }

  void setNetwork(models.NetworkKind network) => emit(state.copyWith(network: network));

  Future<void> reset() async {
    try {
      await usage.reset();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await _load();
  }

  @override
  Future<void> close() async {
    _flush?.cancel();
    await _changes?.cancel();
    return super.close();
  }
}
