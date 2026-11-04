import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/calls.dart';
import 'package:messenger/cdn.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/cubit/call/call_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final other = List<int>.filled(12, 3);

  late FakeApi api;
  late CubitFakeCalls calls;
  late FakeRepositories repositories;

  setUpAll(() async {
    await AppLocale.ru.build();
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() async {
    api = FakeApi();
    calls = CubitFakeCalls();
    repositories = FakeRepositories();
    repositories.contacts.entries = [
      ContactCacheEntry(phoneE164: '+79000000002', displayName: 'Peer contact', phone: '+79000000002', userID: peer),
      ContactCacheEntry(phoneE164: '+79000000003', displayName: 'Other contact', phone: '+79000000003', userID: other),
    ];
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(FakeAuth(models.Session(userID: me)));
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<Repositories>(repositories);
    getIt.registerSingleton<CDNManager>(FakeCDNManager());
    getIt.registerSingleton<Calls>(calls);
  });

  tearDown(() async {
    await calls.dispose();
    await api.dispose();
    await getIt.reset();
  });

  test('CallCubit отображает снимок и разрешает имя собеседника из локального кэша', () async {
    final connectedAt = DateTime(2026, 1, 1);
    calls.snapshot = CallSnapshot(
      status: CallStatus.active,
      callId: 'call-1',
      remoteUserID: peer,
      video: true,
      micMuted: true,
      cameraOff: true,
      speakerOn: true,
      remoteMicMuted: true,
      remoteVideoOff: true,
      remoteOnHold: true,
      reconnecting: true,
      remoteReconnecting: true,
      connectedAt: connectedAt,
      quality: CallQuality.good,
      encryption: CallEncryption.encrypted,
      sas: const ['a', 'b'],
      mediaEpoch: 4,
    );
    final cubit = CallCubit();
    addTearDown(cubit.close);

    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.status, Status.success);
    expect(cubit.state.callStatus, CallStatus.active);
    expect(cubit.state.callId, 'call-1');
    expect(cubit.state.displayName, 'Peer contact');
    expect(cubit.state.video, isTrue);
    expect(cubit.state.micMuted, isTrue);
    expect(cubit.state.cameraOff, isTrue);
    expect(cubit.state.remoteOnHold, isTrue);
    expect(cubit.state.reconnecting, isTrue);
    expect(cubit.state.remoteReconnecting, isTrue);
    expect(cubit.state.connectedAt, connectedAt);
    expect(cubit.state.quality, CallQuality.good);
    expect(cubit.state.encryption, CallEncryption.encrypted);
    expect(cubit.state.sas, ['a', 'b']);
    expect(cubit.state.mediaEpoch, 4);
    expect(api.sentMessages.single.type, MessageType.PROFILE);
    expect(calls.nowPlayingTitles, ['Peer contact']);
  });

  test('CallCubit обновляет участников, уведомления и состояние из новых снимков', () async {
    final cubit = CallCubit();
    addTearDown(cubit.close);
    cubit.initialization();

    calls.emit(
      CallSnapshot(
        status: CallStatus.connecting,
        callId: 'call-2',
        remoteUserID: peer,
        participants: [
          CallParticipant(userID: peer, micMuted: true, speaking: true),
          CallParticipant(userID: other, joined: false),
        ],
        focusUserID: peer,
        inviteNotice: const CallInviteNotice(userID: [], outcome: CallInviteOutcome.busy, seq: 3),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.callStatus, CallStatus.connecting);
    expect(cubit.state.participants, hasLength(2));
    expect(cubit.state.participants[0].name, 'Peer contact');
    expect(cubit.state.participants[0].micMuted, isTrue);
    expect(cubit.state.participants[0].speaking, isTrue);
    expect(cubit.state.participants[1].joined, isFalse);
    expect(cubit.state.focusUserID, peer);
    expect(cubit.state.inviteNoticeOutcome, 'busy');
    expect(cubit.state.inviteNoticeSeq, 3);
  });

  test('CallCubit проксирует действия пользователя и приглашение', () async {
    final cubit = CallCubit();
    addTearDown(cubit.close);

    await cubit.accept();
    await cubit.reject();
    await cubit.hangup();
    await cubit.toggleMic();
    await cubit.toggleCamera();
    await cubit.enableVideo();
    await cubit.pauseVideoForBackground();
    await cubit.resumeVideoAfterBackground();
    await cubit.toggleSpeaker();
    await cubit.switchCamera();
    final result = await cubit.invite(peer);

    expect(result, CallInviteResult.sent);
    expect(calls.actions, [
      'accept',
      'reject',
      'hangup',
      'toggleMic',
      'toggleCamera',
      'enableVideo',
      'pauseVideoForBackground',
      'resumeVideoAfterBackground',
      'toggleSpeaker',
      'switchCamera',
    ]);
    expect(calls.invited, [peer]);
  });

  ChatDialogRow dialog(List<int> userID, int date, int id) => ChatDialogRow(
    chatID: Uint8List.fromList(List<int>.filled(12, id)),
    type: pb.ChatType.CHAT_TYPE_PRIVATE.value,
    peerUserID: Uint8List.fromList(userID),
    topMessage: null,
    topMessageID: 0,
    topMessageDate: date,
    readInboxMaxID: 0,
    readOutboxMaxID: 0,
    unreadCount: 0,
    pinned: false,
    archived: false,
    markedUnread: false,
    mutedUntil: 0,
    draft: '',
    createdAt: 0,
  );

  test('callCandidates сортирует личные чаты и контакты, исключает дубли и участников', () async {
    repositories.chats.dialogItems = [dialog(other, 100, 8), dialog(peer, 200, 9), dialog(me, 300, 1)];
    repositories.contacts.entries = [
      ContactCacheEntry(phoneE164: '+79000000003', displayName: 'Other contact', phone: '+79000000003', userID: other),
      ContactCacheEntry(phoneE164: '+79000000002', displayName: 'Peer contact', phone: '+79000000002', userID: peer),
      ContactCacheEntry(phoneE164: '+79000000004', displayName: 'Alpha', phone: '+79000000004', userID: List<int>.filled(12, 4)),
      ContactCacheEntry(phoneE164: '+79000000005', displayName: '', phone: '+79000000005', userID: List<int>.filled(12, 5)),
      const ContactCacheEntry(phoneE164: '+79000000006', displayName: 'Invite only', phone: '+79000000006'),
    ];

    final candidates = await callCandidates(exclude: [peer]);

    expect(candidates.map((candidate) => candidate.name), ['Other contact', 'Alpha']);
    expect(candidates.first.userID, other);
  });
}

final class CubitFakeCalls implements Calls {
  final _snapshots = StreamController<CallSnapshot>.broadcast(sync: true);
  final actions = <String>[];
  final invited = <List<int>>[];
  final nowPlayingTitles = <String>[];

  @override
  CallSnapshot snapshot = const CallSnapshot();

  @override
  Stream<CallSnapshot> get snapshots => _snapshots.stream;

  void emit(CallSnapshot value) {
    snapshot = value;
    _snapshots.add(value);
  }

  Future<void> _action(String name) async => actions.add(name);

  @override
  Future<void> accept() => _action('accept');
  @override
  Future<void> reject() => _action('reject');
  @override
  Future<void> hangup({CallEndReason reason = CallEndReason.hangup}) => _action('hangup');
  @override
  Future<void> toggleMic() => _action('toggleMic');
  @override
  Future<void> toggleCamera() => _action('toggleCamera');
  @override
  Future<void> enableVideo() => _action('enableVideo');
  @override
  Future<void> pauseVideoForBackground() => _action('pauseVideoForBackground');
  @override
  Future<void> resumeVideoAfterBackground() => _action('resumeVideoAfterBackground');
  @override
  Future<void> toggleSpeaker() => _action('toggleSpeaker');
  @override
  Future<void> switchCamera() => _action('switchCamera');

  @override
  Future<CallInviteResult> invite(List<int> userID) async {
    invited.add(userID);
    return CallInviteResult.sent;
  }

  @override
  Future<void> setIosNowPlaying({required String title, String? subtitle, Uint8List? artwork}) async {
    nowPlayingTitles.add(title);
  }

  @override
  Future<void> dispose() => _snapshots.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAuth implements Auth {
  @override
  final models.Session session;
  const FakeAuth(this.session);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeUtils implements Utils {
  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  models.PhoneNumberModel phoneNormalization({required String phoneNumber}) =>
      const models.PhoneNumberModel(international: '', national: '', e164: '', rfc3966: '', raw: '');

  @override
  List<String> composeNameLines({
    String contactName = '',
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String username,
  }) => [if (contactName.isNotEmpty) contactName else if (firstName.isNotEmpty) firstName else if (username.isNotEmpty) '@$username'];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  late final FakeContacts contacts = FakeContacts();
  @override
  late final FakeProfiles profiles = FakeProfiles();
  @override
  late final FakeChats chats = FakeChats();
  @override
  late final MyProfile myProfile = FakeMyProfile();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeContacts implements Contacts {
  var entries = <ContactCacheEntry>[];

  @override
  Future<List<ContactCacheEntry>> getAll() async => entries;

  @override
  Future<Map<String, String>> namesByUserID({required String Function(List<int>) toHex, List<List<int>>? userIDs}) async => {
    for (final entry in entries)
      if (entry.userID != null && entry.displayName.isNotEmpty && (userIDs == null || userIDs.any((id) => _same(id, entry.userID!))))
        toHex(entry.userID!): entry.displayName,
  };

  @override
  Future<String?> phoneByUserID(List<int> userID) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeProfiles implements Profiles {
  @override
  Future<models.Profile> getByUserID({required List<int> userID}) async => models.Profile(userID: userID);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeChats implements ChatsRepository {
  var dialogItems = <ChatDialogRow>[];

  @override
  Future<List<ChatDialogRow>> dialogs({required List<int> userID}) async => dialogItems;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeMyProfile implements MyProfile {
  @override
  Future<models.MyProfile> getByUserID({required List<int> userID}) async => const models.MyProfile();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCDNManager implements CDNManager {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

bool _same(List<int> a, List<int> b) => a.length == b.length && [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((value) => value);
