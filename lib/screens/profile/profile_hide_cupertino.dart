import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../themes.dart';

/// Экран «Скрыть профиль» (iOS): задать код-фразу (скрыть собеседника из моих
/// списков) или сбросить (показать снова). Сброс доступен всегда, даже если
/// профиль ещё не скрыт. См. [ProfileHideCubit].
class ProfileHideCupertino extends StatefulWidget {
  const ProfileHideCupertino({super.key});

  @override
  State<ProfileHideCupertino> createState() => _ProfileHideCupertino();
}

class _ProfileHideCupertino extends State<ProfileHideCupertino> {
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
          showCupertinoDialog<void>(
            context: context,
            builder: (dialogContext) => CupertinoAlertDialog(
              content: Text(context.t[state.error]),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(context.t.common.close),
                ),
              ],
            ),
          );
          return;
        }
        if (state.saved) context.pop();
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenHideProfile.title),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: Text(context.t.common.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.read<ProfileHideCubit>().hide(_phraseController.text),
                child: Text(context.t.screenHideProfile.hideAction, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                CupertinoFormSection.insetGrouped(
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  footer: Padding(padding: const EdgeInsets.only(top: 8), child: Text(context.t.screenHideProfile.description)),
                  children: [
                    CupertinoTextFormFieldRow(
                      placeholder: context.t.screenHideProfile.phrasePlaceholder,
                      controller: _phraseController,
                      autofocus: true,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                  ],
                ),
                // Сброс доступен всегда (даже если профиль не скрыт).
                CupertinoListSection.insetGrouped(
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(
                        context.t.screenHideProfile.resetAction,
                        style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context)),
                      ),
                      onTap: () => context.read<ProfileHideCubit>().reset(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
