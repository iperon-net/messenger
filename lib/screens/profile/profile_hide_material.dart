import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../themes.dart';

/// Экран «Скрыть профиль» (Android): задать код-фразу (скрыть собеседника из
/// моих списков) или сбросить (показать снова). Сброс доступен всегда, даже если
/// профиль ещё не скрыт. См. [ProfileHideCubit].
class ProfileHideMaterial extends StatefulWidget {
  const ProfileHideMaterial({super.key});

  @override
  State<ProfileHideMaterial> createState() => _ProfileHideMaterial();
}

class _ProfileHideMaterial extends State<ProfileHideMaterial> {
  final _phraseController = TextEditingController();
  final logger = getIt.get<Logger>();

  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileHideCubit, ProfileHideState>(
      listenWhen: (previous, current) => previous.saved != current.saved || previous.error != current.error,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              content: Text(context.t[state.error]),
              actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.close))],
            ),
          );
          return;
        }
        if (state.saved) context.pop();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.screenHideProfile.title),
            actions: [
              TextButton(
                onPressed: () => context.read<ProfileHideCubit>().hide(_phraseController.text),
                child: FaIcon(FontAwesomeIcons.check, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _phraseController,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: context.t.screenHideProfile.phrasePlaceholder,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: Text(
                    context.t.screenHideProfile.description,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                //   child: Text(
                //     context.t.screenHideProfile.description,
                //     style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: AppFontSizes.label),
                //   ),
                // ),
                // Сброс доступен всегда (даже если профиль не скрыт).
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: Text(context.t.screenHideProfile.resetAction, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    onTap: () => context.read<ProfileHideCubit>().reset(),
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
