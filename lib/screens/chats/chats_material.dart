import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';

class ChatsMaterial extends StatefulWidget {
  const ChatsMaterial({super.key});

  @override
  State<ChatsMaterial> createState() => _ChatsMaterial();
}

class _ChatsMaterial extends State<ChatsMaterial> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: ConnectionTitle(
              title: context.t.screenChats.chats,
              leading: BlocBuilder<CommonCubit, CommonState>(
                builder: (context, stateCommon) {
                  if (stateCommon.settingsDevice.passcode.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () async => await context.read<CommonCubit>().forceLock(biometrics: false),
                        child: const FaIcon(FontAwesomeIcons.lockOpen, size: 18),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          body: Column(
            children: [
              // Мягкий баннер-объяснение о разрешении на уведомления. Виден, только
              // пока разрешения нет и пользователь его не закрыл.
              BlocSelector<ChatsCubit, ChatsState, bool>(
                selector: (state) => state.showNotificationsBanner,
                builder: (context, show) {
                  if (!show) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PermissionBannerMaterial(
                      icon: HugeIcons.strokeRoundedNotification03,
                      title: context.t.screenChats.notificationPermissionTitle,
                      message: context.t.screenChats.notificationPermissionMessage,
                      actionLabel: context.t.screenChats.allowAccess,
                      onAction: () => context.read<ChatsCubit>().requestNotificationPermission(),
                      onDismiss: () => context.read<ChatsCubit>().dismissNotificationsBanner(),
                      dismissTooltip: context.t.common.notNow,
                    ),
                  );
                },
              ),
              const Expanded(child: Center(child: Text("ccc"))),
            ],
          ),
        );
      },
    );
  }
}
