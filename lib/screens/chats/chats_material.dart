import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            title: ConnectionTitle(title: context.t.screenChats.chats),
            leading: BlocBuilder<CommonCubit, CommonState>(
              builder: (context, stateCommon) {
                if (stateCommon.settingsDevice.passcode.isNotEmpty) {
                  return IconButton(
                    icon: const FaIcon(FontAwesomeIcons.lockOpen, size: 18),
                    onPressed: () async => await context.read<CommonCubit>().forceLock(biometrics: false),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          body: const Center(child: Text("ccc")),
        );
      },
    );
  }
}
