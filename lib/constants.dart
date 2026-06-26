enum Status { initialization, loading, success }

enum SyncerMessageType {
  authRequest(1),
  authResponse(2),
  logoutRequest(3),
  logoutResponse(4),
  sessionsRequest(5),
  sessionsResponse(6);

  final int value;
  const SyncerMessageType(this.value);

  // Статический метод для получения enum по значению
  static SyncerMessageType fromValue(int value) {
    return values.firstWhere(
          (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }
}
