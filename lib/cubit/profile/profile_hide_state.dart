import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'profile_hide_state.mapper.dart';

/// Состояние экрана «Скрыть профиль». [isHidden] — скрыт ли профиль сейчас (для
/// подписи и доступности «Сбросить»); [error] — i18n-ключ ошибки (пустая фраза);
/// [saved] — операция (скрыть/сбросить) прошла успешно, экрану пора закрыться.
@MappableClass()
class ProfileHideState with ProfileHideStateMappable {
  final Status status;
  final bool isHidden;
  final String error;
  final bool saved;

  const ProfileHideState({this.status = Status.initialization, this.isHidden = false, this.error = "", this.saved = false});
}
