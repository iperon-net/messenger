import 'package:cupertino_ui/cupertino_ui.dart';
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
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            backgroundColor: CupertinoColors.systemGroupedBackground,
            middle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.lockOpen,
                  size: 16,
                  color: CupertinoTheme.brightnessOf(context) == Brightness.dark
                      ? CupertinoColors.white
                      : CupertinoColors.black,
                ),
                SizedBox(width: 10),
                ConnectionTitle(title: context.t.common.chats),
              ],
            ),
          ),
          child: Center(child: Text("ccc")),
        );
      },
    );
  }
}
