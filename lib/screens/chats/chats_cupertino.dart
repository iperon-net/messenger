import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';

class ChatsCupertino extends StatefulWidget {
  const ChatsCupertino({super.key});

  @override
  State<ChatsCupertino> createState() => _ChatsCupertino();
}

class _ChatsCupertino extends State<ChatsCupertino> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<CommonCubit, CommonState>(
                    builder: (context, stateCommon) {
                      if (stateCommon.settingsDevice.passcode.isNotEmpty) {
                        return GestureDetector(
                          onTap: () async => await context.read<CommonCubit>().forceLock(biometrics: false),
                          child: FaIcon(
                            FontAwesomeIcons.lockOpen,
                            size: 16,
                            color: CupertinoTheme.brightnessOf(context) == Brightness.dark ? CupertinoColors.white : CupertinoColors.black,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(width: 10),
                  ConnectionTitle(title: context.t.screenChats.chats),
                ],
              ),
            ),
          ),
          child: Center(child: Text("ccc")),
        );
      },
    );
  }
}
