import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart';

part 'settings_network_state.mapper.dart';

@MappableClass()
class SettingsNetworkState with SettingsNetworkStateMappable {
  final Status status;

  /// Показываемая сеть (переключатель вверху экрана).
  final NetworkKind network;
  final Map<TrafficCategory, TrafficCounter> mobile;
  final Map<TrafficCategory, TrafficCounter> wifi;

  /// С какого момента считается; `null` — трафика ещё не было.
  final DateTime? since;

  const SettingsNetworkState({
    this.status = Status.initialization,
    this.network = NetworkKind.mobile,
    this.mobile = const {},
    this.wifi = const {},
    this.since,
  });

  Map<TrafficCategory, TrafficCounter> get current => network == NetworkKind.mobile ? mobile : wifi;

  TrafficCounter get total => current.values.fold(
    const TrafficCounter(),
    (sum, counter) => TrafficCounter(sent: sum.sent + counter.sent, received: sum.received + counter.received),
  );
}
