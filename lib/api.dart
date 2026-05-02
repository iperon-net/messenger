import 'package:package_info_plus/package_info_plus.dart';

import 'di.dart';
import 'logger.dart';
import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

import 'protobuf/protos/auth_v1.pbgrpc.dart';
import 'protobuf/protos/metadata_v1.pbgrpc.dart';

class API {
  final _logger = getIt.get<Logger>();

  late ClientChannel _clientChannel;
  late AuthClient auth;
  late MetadataClient metadata;
  late String version;

  final uuid = Uuid();
  API() {
    // final host = "development.iperon.net";
    final host = "staging.iperon.net";

    _clientChannel = ClientChannel(
      host,
      port: 443,
      options: ChannelOptions(
        connectionTimeout: const Duration(seconds: 30),
        connectTimeout:  const Duration(seconds: 30), // The maximum allowed time to wait for a connection to be established
        userAgent: "Iperon/0.0.1",
        idleTimeout: const Duration(minutes: 60),
        backoffStrategy: (_) => const Duration(seconds: 60),
        keepAlive: const ClientKeepAliveOptions(
          pingInterval: Duration(seconds: 60),
        ),
        codecRegistry: CodecRegistry(
          codecs: const [
            GzipCodec(),
            IdentityCodec(),
          ],
        ),

      ),
      channelShutdownHandler: () {
        _logger.debug('channelShutdownHandler');
      },
    );

    auth = AuthClient(_clientChannel);
    metadata = MetadataClient(_clientChannel);

    _logger.info("api initialization");
  }


  // Initialization
  Future<void> initialization() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }


  Future<String> call(Function() func) async {
    Logger logger = getIt.get<Logger>();

    try {
      await func();
    } on GrpcError catch(err) {
      logger.error(err.toString());

      if ([StatusCode.unknown, StatusCode.unavailable].contains(err.code)) {
        return "errorConnectingToTheServer";
      } else if ([StatusCode.deadlineExceeded].contains(err.code)) {
        return "unableToConnectToTheServer";
      } else if ([StatusCode.cancelled, StatusCode.invalidArgument].contains(err.code)) {
        return err.message.toString();
      } else if ([StatusCode.internal].contains(err.code)) {
        return "internalServerError";
      }

    } catch (err) {
      rethrow;
    }

    return "";

  }

  Future<CallOptions> callOptions({double timeout = 30}) async {
    return CallOptions(
      timeout: Duration(seconds: timeout.toInt()),
      metadata: {
        "x-app-version": "v$version",
        "x-request-id": uuid.v4(),
      },
    );
  }

}
