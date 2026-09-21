import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'profile_hide_state.dart';

/// Экран «Скрыть профиль»: локально прячет собеседника из списков Контактов и
/// Звонков (и будущих Чатов) на этом устройстве. Код-фраза своя на каждый
/// профиль — по ней («/фраза» в поиске) профиль снова показывается. Всё
/// локально (см. [HiddenProfiles]); на сервер ничего не уходит.
class ProfileHideCubit extends Cubit<ProfileHideState> {
  ProfileHideCubit({required this.userID}) : super(const ProfileHideState());

  /// Сырые байты ObjectID скрываемого пользователя.
  final List<int> userID;

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  Future<void> initialization() async {
    final hidden = await repositories.hiddenProfiles.isHidden(userID);
    if (isClosed) return;
    emit(state.copyWith(status: Status.success, isHidden: hidden));
  }

  /// Скрывает профиль под заданной код-фразой. Пустая фраза — ошибка. Храним
  /// только sha256 фразы (см. `Utils.passphraseHash`), саму фразу — нигде.
  Future<void> hide(String phrase) async {
    if (phrase.trim().isEmpty) {
      emit(state.copyWith(error: "screenHideProfile.errorEmptyPhrase"));
      return;
    }
    final hash = await utils.passphraseHash(phrase);
    if (isClosed) return;
    await repositories.hiddenProfiles.hide(userID: userID, phraseHash: hash);
    if (isClosed) return;
    emit(state.copyWith(error: "", isHidden: true, saved: true));
  }

  /// Снимает скрытие — профиль снова виден. Разрешено всегда, даже если профиль
  /// не был скрыт (идемпотентно).
  Future<void> reset() async {
    await repositories.hiddenProfiles.unhide(userID);
    if (isClosed) return;
    emit(state.copyWith(error: "", isHidden: false, saved: true));
  }
}
