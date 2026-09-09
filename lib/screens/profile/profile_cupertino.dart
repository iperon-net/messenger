import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../themes.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';

/// Просмотр публичного профиля чужого пользователя (read-only): аватар, ФИО,
/// телефон, username, «о себе».
class ProfileCupertino extends StatefulWidget {
  const ProfileCupertino({super.key});

  @override
  State<ProfileCupertino> createState() => _ProfileCupertino();
}

class _ProfileCupertino extends State<ProfileCupertino> {
  final logger = getIt.get<Logger>();

  Widget _fieldTile(BuildContext context, String label, String value) {
    return CupertinoListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: AppFontSizes.body)),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.value,
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoTheme.of(context).primaryColor,
                darkColor: CupertinoColors.white.withValues(alpha: 0.5),
              ).resolveFrom(context),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final firstNameTile = state.firstName.isNotEmpty ? _fieldTile(context, context.t.screenProfile.firstName, state.firstName) : null;
        final lastNameTile = state.lastName.isNotEmpty ? _fieldTile(context, context.t.screenProfile.lastName, state.lastName) : null;
        // В русской локали принят порядок «фамилия, имя», в остальных — «имя, фамилия».
        final nameTiles = <Widget>[
          if (state.locale == AppLocale.ru) ...[?lastNameTile, ?firstNameTile] else ...[?firstNameTile, ?lastNameTile],
        ];

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenProfile.profile),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: Icon(CupertinoIcons.back, color: ThemesCupertino.navActionColor(context)),
              ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: state.avatarBytes != null
                        ? ClipOval(child: Image.memory(state.avatarBytes!, width: 96, height: 96, fit: BoxFit.cover, gaplessPlayback: true))
                        : AnimatedBoringAvatar(
                            name: state.boringAvatarHash,
                            type: state.boringAvatarType,
                            shape: const CircleBorder(),
                            curve: Curves.bounceIn,
                            duration: const Duration(seconds: 1),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                if (nameTiles.isNotEmpty || state.phoneNumber.isNotEmpty)
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      ...nameTiles,
                      if (state.phoneNumber.isNotEmpty)
                        CopyTooltip(
                          value: state.phoneNumber,
                          label: context.t.screenProfile.copy,
                          child: _fieldTile(context, context.t.screenProfile.mobilePhone, state.phoneNumber),
                        ),
                    ],
                  ),
                if (state.username.isNotEmpty)
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CopyTooltip(
                        value: state.username,
                        label: context.t.screenProfile.copy,
                        child: CupertinoListTileIcon(
                          title: Text(state.username),
                          color: Color(0xFF3B74BF),
                          icon: FontAwesomeIcons.at,
                          onTab: null,
                          additionalInfo: Text(context.t.screenProfile.username),
                          isTrailing: true,
                        ),
                      ),
                    ],
                  ),
                if (state.aboutMe.isNotEmpty)
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [_fieldTile(context, context.t.screenProfile.aboutMe, state.aboutMe)],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
