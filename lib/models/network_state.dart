enum NetworkStateConnectivityType { wifi, mobile, vpn, ethernet, none }

class NetworkState {
  final String message;

  NetworkState({this.message = ""});
}
