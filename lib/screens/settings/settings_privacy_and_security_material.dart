import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../../utils.dart';
import '../chats/chat_ttl.dart';

class SettingsPrivacyAndSecurityMaterial extends StatefulWidget {
  const SettingsPrivacyAndSecurityMaterial({super.key});

  @override
  State<SettingsPrivacyAndSecurityMaterial> createState() => _SettingsPrivacyAndSecurityMaterial();
}

class _SettingsPrivacyAndSecurityMaterial extends State<SettingsPrivacyAndSecurityMaterial> {
  final utils = getIt.get<Utils>();

  String _audienceLabel(BuildContext context, CallsPrivacyAudience audience) {
    switch (audience) {
      case CallsPrivacyAudience.everybody:
        return context.t.sessionsPrivacyAndSecurity.callsEverybody;
      case CallsPrivacyAudience.contacts:
        return context.t.sessionsPrivacyAndSecurity.callsContacts;
      case CallsPrivacyAudience.nobody:
        return context.t.sessionsPrivacyAndSecurity.callsNobody;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.t.sessionsPrivacyAndSecurity.privacyAndSecurity)),
          body: SafeArea(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      MaterialListTileIcon(
                        title: state.isBiometricAvailable
                            ? Text(context.t.sessionsPrivacyAndSecurity.passcodeAndBiometric)
                            : Text(context.t.sessionsPrivacyAndSecurity.passcode),
                        color: const Color(0xFF41CA22),
                        icon: FontAwesomeIcons.unlockKeyhole,
                        onTab: () async => context.go("/settings/privacy_and_security/passcode"),
                        isTrailing: true,
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.cloudPassword),
                        color: const Color(0xFF5856D6),
                        icon: FontAwesomeIcons.cloud,
                        onTab: () async => context.go("/settings/privacy_and_security/cloud_password"),
                        isTrailing: true,
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.passkeys),
                        color: const Color(0xFFFF9500),
                        icon: FontAwesomeIcons.key,
                        onTab: () async => context.go("/settings/privacy_and_security/passkeys"),
                        isTrailing: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.privacyAndSecurity,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.calls),
                        color: const Color(0xFF007AFF),
                        icon: FontAwesomeIcons.phone,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.callsAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/calls");
                          // Детейл-экран правит свой инстанс cubit — по возврату
                          // перечитываем значение, чтобы label не остался старым.
                          await cubit.reloadCalls();
                        },
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.birthday),
                        color: const Color(0xFFFF2D55),
                        icon: FontAwesomeIcons.cakeCandles,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.birthdayAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/birthday");
                          await cubit.reloadBirthday();
                        },
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.aboutMe),
                        color: const Color(0xFFAF52DE),
                        icon: FontAwesomeIcons.circleInfo,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.aboutMeAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/about_me");
                          await cubit.reloadAboutMe();
                        },
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.lastSeen),
                        color: const Color(0xFF34C759),
                        icon: FontAwesomeIcons.solidClock,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.lastSeenAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/last_seen");
                          await cubit.reloadLastSeen();
                        },
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.messages),
                        color: const Color(0xFF5AC8FA),
                        icon: FontAwesomeIcons.solidComment,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.messagesAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/messages");
                          await cubit.reloadMessages();
                        },
                      ),
                      MaterialListTileIcon(
                        title: Text(context.t.sessionsPrivacyAndSecurity.forwards),
                        color: const Color(0xFF5856D6),
                        icon: FontAwesomeIcons.share,
                        isTrailing: true,
                        additionalInfo: Text(state.callsLoadError ? "—" : _audienceLabel(context, state.forwardsAudience)),
                        onTab: () async {
                          final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                          await context.push("/settings/privacy_and_security/forwards");
                          await cubit.reloadForwards();
                        },
                      ),
                    ],
                  ),
                ),
                // Автоудаление по умолчанию для новых чатов (как в Telegram).
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                  child: MaterialListTileIcon(
                    title: Text(context.t.chatTtl.titleLong),
                    color: const Color(0xFF8E8E93),
                    icon: FontAwesomeIcons.stopwatch,
                    isTrailing: true,
                    additionalInfo: Text(state.callsLoadError ? "—" : chatTTLLabel(context.t, state.messagesTTL)),
                    onTab: state.callsReadOnly
                        ? null
                        : () async {
                            final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
                            final messenger = ScaffoldMessenger.of(context);
                            final message = context.t.common.noConnectionMessage;
                            final period = await pickChatTTLMaterial(context, state.messagesTTL);
                            if (period == null || period == state.messagesTTL) return;
                            if (!await cubit.setMessagesTTL(period)) messenger.showSnackBar(SnackBar(content: Text(message)));
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    context.t.chatTtl.defaultFooter,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
