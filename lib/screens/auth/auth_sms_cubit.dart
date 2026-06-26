import 'package:bloc/bloc.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/auth_v1.pb.dart';

import '../../api.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';
import 'auth_sms_state.dart';

class AuthSmsCubit extends Cubit<AuthSmsState> {
  AuthSmsCubit() : super(const AuthSmsState());

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _services = getIt.get<Services>();
  final _repositories = getIt.get<Repositories>();

  /// Проверка кода из SMS. Не знает про навигацию/`MainCubit` — при успехе
  /// возвращает данные сессии, экран сам активирует их и переходит дальше.
  /// `null` — код не подошёл (экран показывает ошибку поля ввода).
  Future<({models.User user, models.Session session})?> smsCheck({required List<int> smsSession, required String verificationCode}) async {

    late AuthSMSCheckResponse response;
    final error = await _api.call(() async {
      final req = AuthSMSCheckRequest(smsSession: smsSession, verificationCode: verificationCode);
      response = await _api.auth.sMSCheck(req, options: await _api.callOptions());
    });

    if (isClosed) return null;

    if (error.isNotEmpty) {
      _logger.error(error);
      return null;
    }

    final confirmation = await _services.auth.confirmation(confirmationSession: response.confirmationSession);
    if (isClosed || confirmation.error.isNotEmpty) return null;

    final session = await _repositories.sessions.getActive();
    final user = await _repositories.users.getBySession(session: session);

    if (isClosed) return null;
    return (user: user, session: session);
  }
}
