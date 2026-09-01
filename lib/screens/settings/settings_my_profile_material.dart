import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:messenger/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';

class SettingsMyProfileMaterial extends StatefulWidget {
  const SettingsMyProfileMaterial({super.key});

  @override
  State<SettingsMyProfileMaterial> createState() => _SettingsMyProfileMaterial();
}

class _SettingsMyProfileMaterial extends State<SettingsMyProfileMaterial> {
  final logger = getIt.get<Logger>();

  /// Открывает лист выбора источника аватара (галерея / файл / эмодзи / ссылка).
  Future<void> _pickAvatar(BuildContext context) async {
    // Заголовок кропа берём заранее: коллбэк [processImage] отработает уже из
    // открытого листа, где своего доступа к этому контексту у него нет.
    final editTitle = context.t.screenMyProfile.editPhoto;
    final result = await showToolbarAttachments(
      context,
      tabs: const [
        ToolbarAttachmentTabKind.gallery,
        // ToolbarAttachmentTabKind.file,
        // ToolbarAttachmentTabKind.emoji,
        // ToolbarAttachmentTabKind.link,
      ],
      // Кроп аватара — внутри листа: отмена возвращает в галерею, а не закрывает
      // лист. Лист закроется лишь при успешном кропе.
      processImage: (file) => _cropAvatar(file, editTitle),
    );
    if (result == null) return; // лист закрыт без выбора

    switch (result) {
      case ToolbarAttachmentImageResult(:final file):
        // Файл уже обрезан внутри листа ([_cropAvatar]).
        logger.debug('Выбран аватар: ${file.path}');
        final bytes = await file.readAsBytes();
        if (!context.mounted) return;
        context.read<SettingsMyProfileCubit>().setAvatar(bytes);

      case ToolbarAttachmentMultiImageResult(:final files):
        logger.debug('Выбрано медиа: ${files.map((f) => f.path).join(', ')}');
      case ToolbarAttachmentEmojiResult(:final emoji):
        logger.debug('Выбран эмодзи-аватар: $emoji');
      case ToolbarAttachmentLinkResult(:final url):
        logger.debug('Выбран аватар по ссылке: $url');
    }
  }

  /// Круглый кроп 1:1 выбранного фото. Возвращает обрезанный файл или `null`,
  /// если пользователь отменил обрезку (тогда лист остаётся открытым).
  Future<XFile?> _cropAvatar(XFile file, String title) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        IOSUiSettings(title: title, cropStyle: CropStyle.circle, aspectRatioLockEnabled: true, resetAspectRatioEnabled: false),
        AndroidUiSettings(toolbarTitle: title, cropStyle: CropStyle.circle, lockAspectRatio: true),
      ],
    );
    return cropped == null ? null : XFile(cropped.path);
  }

  Widget _fieldTile(BuildContext context, String label, String value) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(14))),
          Text(
            value,
            style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(17), color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileCubit, SettingsMyProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        final firstNameTile = state.firstName.isNotEmpty ? _fieldTile(context, context.t.screenMyProfile.firstName, state.firstName) : null;
        final lastNameTile = state.lastName.isNotEmpty ? _fieldTile(context, context.t.screenMyProfile.lastName, state.lastName) : null;
        // В русской локали принят порядок «фамилия, имя», в остальных — «имя, фамилия».
        final nameTiles = <Widget>[
          if (state.locale == AppLocale.ru) ...[?lastNameTile, ?firstNameTile] else ...[?firstNameTile, ?lastNameTile],
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.screenMyProfile.myprofile),
            actions: [
              // push (а не go): дожидаемся закрытия экрана правки и перечитываем
              // профиль из локальной БД — экран профиля не пересоздаётся при
              // возврате, поэтому обновляем его вручную.
              state.networkStatus == Status.loading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : TextButton(
                      onPressed: () async {
                        final cubit = context.read<SettingsMyProfileCubit>();
                        await context.push("/settings/profile/edit");
                        await cubit.reload();
                      },
                      child: FaIcon(FontAwesomeIcons.penToSquare, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () => _pickAvatar(context),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 96,
                          height: 96,
                          child: state.avatarBytes != null
                              ? ClipOval(
                                  child: Image.memory(state.avatarBytes!, width: 96, height: 96, fit: BoxFit.cover, gaplessPlayback: true),
                                )
                              : AnimatedBoringAvatar(
                                  name: state.boringAvatarHash,
                                  type: state.boringAvatarType,
                                  shape: const CircleBorder(),
                                  curve: Curves.bounceIn,
                                  duration: const Duration(seconds: 1),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.t.screenMyProfile.editPhoto,
                          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ...nameTiles,
                      CopyTooltip(
                        value: state.phoneNumber,
                        label: context.t.screenMyProfile.copy,
                        child: _fieldTile(context, context.t.screenMyProfile.mobilePhone, state.phoneNumber),
                      ),
                      if (state.username.isNotEmpty)
                        CopyTooltip(
                          value: '@${state.username}',
                          label: context.t.screenMyProfile.copy,
                          child: _fieldTile(context, context.t.screenMyProfile.username, '@${state.username}'),
                        ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialListTileIcon(
                    title: Text(context.t.screenMyProfile.username),
                    color: const Color(0xFF3B74BF),
                    icon: FontAwesomeIcons.at,
                    onTab: () async {},
                    additionalInfo: Text(state.username.isNotEmpty ? context.t.screenMyProfile.edit : context.t.screenMyProfile.add),
                    isTrailing: true,
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
