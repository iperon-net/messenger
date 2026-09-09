import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../components.dart';
import '../../themes.dart';
import '../../i18n/translations.g.dart';

/// Просмотр публичного профиля чужого пользователя (read-only): аватар, ФИО,
/// телефон, username, «о себе».
class ProfileMaterial extends StatefulWidget {
  const ProfileMaterial({super.key});

  @override
  State<ProfileMaterial> createState() => _ProfileMaterial();
}

class _ProfileMaterial extends State<ProfileMaterial> {
  final logger = getIt.get<Logger>();

  Widget _fieldTile(BuildContext context, String label, String value) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: AppFontSizes.label)),
          Text(
            value,
            style: TextStyle(fontSize: AppFontSizes.value, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
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

        return Scaffold(
          appBar: AppBar(title: Text(context.t.screenProfile.profile)),
          body: SafeArea(
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
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
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
                  ),
                if (state.username.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                    clipBehavior: Clip.antiAlias,
                    child: CopyTooltip(
                      value: state.username,
                      label: context.t.screenProfile.copy,
                      child: MaterialListTileIcon(
                        title: Text(state.username),
                        color: const Color(0xFF3B74BF),
                        icon: FontAwesomeIcons.at,
                        onTab: null,
                        additionalInfo: Text(context.t.screenProfile.username),
                        isTrailing: true,
                      ),
                    ),
                  ),
                if (state.aboutMe.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                    clipBehavior: Clip.antiAlias,
                    child: _fieldTile(context, context.t.screenProfile.aboutMe, state.aboutMe),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
