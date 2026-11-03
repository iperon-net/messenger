import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

class SettingsPrivacyAutoDeleteCupertino extends StatelessWidget {
  const SettingsPrivacyAutoDeleteCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
      child: BlocBuilder<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
        builder: (context, state) => CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.accountDeletion.autoDeleteTitle),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  footer: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(context.t.accountDeletion.autoDeleteDescription, style: TextStyle(fontSize: AppFontSizes.caption)),
                  ),
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    for (final months in const [3, 6, 12])
                      CupertinoListTile(
                        title: Text(context.t.accountDeletion.months(count: months)),
                        additionalInfo: state.autoDeletePeriodMonths == months
                            ? FaIcon(FontAwesomeIcons.solidCircleCheck, size: 18, color: CupertinoTheme.of(context).primaryColor)
                            : null,
                        onTap: state.callsReadOnly || state.callsLoadError
                            ? null
                            : () async {
                                final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setAutoDeletePeriod(months);
                                if (!ok && context.mounted) {
                                  await showCupertinoDialog<void>(
                                    context: context,
                                    builder: (dialogContext) => CupertinoAlertDialog(
                                      title: Text(context.t.common.noConnectionTitle),
                                      content: Text(context.t.common.noConnectionMessage),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () => Navigator.pop(dialogContext),
                                          child: Text(context.t.common.close),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
