import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final logger = getIt.get<Logger>();
  final crypto = getIt.get<Crypto>();
  final auth = getIt.get<Auth>();
  final api = getIt.get<API>();

  StreamSubscription<Uint8List>? _sub;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // await api.sendEncoded(MessageType.DEVICE_SESSIONS, DeviceSessions_Request().writeToBuffer());
    //
    // _sub = api.on(MessageType.DEVICE_SESSIONS).listen((payload) {
    //   final response = DeviceSessions_Response.fromBuffer(payload);
    //   logger.debug(response.results);
    // });



    // api.incoming.listen((data){
    //   logger.debug(data);
    // });
    //
    // api.send(messageSessionRequest);

    // final messageSessionRequest = Message(
    //   messageType: MessageType.SESSIONS,
    //   message: await crypto.syncer.encode(
    //     session: auth.session,
    //     message: Sessions_Request().writeToBuffer(),
    //   ),
    // );
    //
    // late Message messageSessionResponse;
    // final sessionGrpcError = await api.call(() async {
    //   messageSessionResponse = await api.client.unary(messageSessionRequest);
    // });
    //
    // if (sessionGrpcError.status == APIStatus.error) {
    //   logger.error(sessionGrpcError);
    // }
    //
    // final decode = await crypto.syncer.decode(session: auth.session, message: Uint8List.fromList(messageSessionResponse.message));
    // final results = Sessions_Response.fromBuffer(decode);
    // logger.debug(results.results);

    emit(state.copyWith(status: Status.success));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

}
