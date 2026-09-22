import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../extensions.dart';

import '../../auth.dart';
import '../../calls.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../themes.dart';
import '../../utils.dart';
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

  /// Свой ли это профиль — на нём кнопку звонка не показываем.
  bool _isSelf(List<int> userID) => listEquals(userID, getIt.get<Auth>().session.userID);

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

        final birthDate = state.birthDate;
        final birthDateTile = birthDate != null
            ? _fieldTile(
                context,
                context.t.screenProfile.birthDate,
                // Владелец скрыл год → только «9 мая» (без года и возраста).
                // Иначе «9 мая 1981 (43 года)» — день, месяц, год + возраст в скобках.
                state.hideBirthYear
                    ? DateFormat('d MMMM').format(birthDate)
                    : '${DateFormat('d MMMM y').format(birthDate)} (${context.t.screenProfile.age(n: birthDate.ageInYears())})',
              )
            : null;
        final hasSection = nameTiles.isNotEmpty || birthDateTile != null || state.phoneNumber.isNotEmpty || state.username.isNotEmpty;

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              // end:0 — прижимаем правую группу кнопок к краю (по умолчанию навбар
              // добавляет 16pt); start:16 оставляем стандартным.
              padding: const EdgeInsetsDirectional.only(start: 16, end: 0),
              middle: Text(context.t.screenProfile.profile),
              trailing: (state.userID.isNotEmpty && !_isSelf(state.userID))
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(44, 44),
                          onPressed: () => getIt.get<Calls>().startCall(toUserID: state.userID, video: false),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCall02,
                            color: ThemesCupertino.navActionColor(context),
                            size: 22.0,
                            strokeWidth: 2,
                          ),
                        ),
                        CupertinoButton(
                          // 44×44 — минимальная зона нажатия по HIG; прежние
                          // padding:zero + minimumSize:zero давали хит-area размером с
                          // саму иконку (~20pt), поэтому тап часто не срабатывал.
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(44, 44),
                          onPressed: () => getIt.get<Calls>().startCall(toUserID: state.userID, video: true),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedVideo01,
                            color: ThemesCupertino.navActionColor(context),
                            size: 22.0,
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    )
                  : null,
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
                        ? ClipOval(
                            child: Image.memory(
                              state.avatarBytes!,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              // См. profile_material.dart: декодируем под размер слота, а не
                              // в полный битмап исходной (крупной) аватарки.
                              cacheWidth: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                              cacheHeight: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                            ),
                          )
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
                if (hasSection)
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      ...nameTiles,
                      ?birthDateTile,
                      if (state.phoneNumber.isNotEmpty)
                        CopyTooltip(
                          value: state.phoneNumber,
                          label: context.t.screenProfile.copy,
                          child: _fieldTile(context, context.t.screenProfile.mobilePhone, state.phoneNumber),
                        ),
                      if (state.username.isNotEmpty)
                        CopyTooltip(
                          value: state.username,
                          label: context.t.screenProfile.copy,
                          child: _fieldTile(context, context.t.screenProfile.username, state.username),
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
                // «Скрыть профиль» — только для чужого профиля (свой прятать из
                // своих же списков смысла нет).
                if (state.userID.isNotEmpty && !_isSelf(state.userID))
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoListTileIcon(
                        title: Text(context.t.screenProfile.hideProfile),
                        color: const Color(0xFF22D393),
                        hugeIcon: HugeIcons.strokeRoundedLockPassword,
                        isTrailing: true,
                        onTab: () => context.push('/profile/${getIt.get<Utils>().bytesToHex(Uint8List.fromList(state.userID))}/hide'),
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
