import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';

class SettingsMyProfileCupertino extends StatefulWidget {
  const SettingsMyProfileCupertino({super.key});

  @override
  State<SettingsMyProfileCupertino> createState() => _SettingsMyProfileCupertino();
}

class _SettingsMyProfileCupertino extends State<SettingsMyProfileCupertino> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final firstNameFocus = FocusNode();
  final lastNameController = TextEditingController();
  final lastNameFocus = FocusNode();

  final logger = getIt.get<Logger>();

  // Локальное состояние макета (кубит не реализуем).
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Макет выбора фотографии — реального пикера пока нет.
  // void _pickPhoto() {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (context) => CupertinoActionSheet(
  //       title: const Text("Фото профиля"),
  //       actions: [
  //         CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Сделать фото")),
  //         CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Выбрать из галереи")),
  //         CupertinoActionSheetAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: const Text("Удалить фото")),
  //       ],
  //       cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
  //     ),
  //   );
  // }

  // Выбор даты рождения снизу — как в iOS-настройках.
  void _pickBirthDate() {
    DateTime temp = _birthDate ?? DateTime(2000, 1, 1);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
                  CupertinoButton(
                    onPressed: () {
                      setState(() => _birthDate = temp);
                      Navigator.pop(context);
                    },
                    child: const Text("Готово"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: temp,
                maximumDate: DateTime.now(),
                minimumYear: 1900,
                onDateTimeChanged: (value) => temp = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String get _birthDateLabel {
  //   final d = _birthDate;
  //   if (d == null) return "Не указана";
  //   return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileCubit, SettingsMyProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenMyProfile.myprofile),
              leading: CupertinoButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), child: Text(context.t.common.cancel)),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    logger.debug("validate ok!");
                  }
                },
                child: Text(context.t.common.save),
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                children: [
                  // const SizedBox(height: 12),
                  // // Аватарка с кнопкой выбора фото.
                  // Center(
                  //   child: GestureDetector(
                  //     onTap: _pickPhoto,
                  //     behavior: HitTestBehavior.opaque,
                  //     child: Column(
                  //       children: [
                  //         Stack(
                  //           children: [
                  //             SizedBox(
                  //               width: 96,
                  //               height: 96,
                  //               child: AnimatedBoringAvatar(
                  //                 name: state.boringAvatarHash,
                  //                 type: state.boringAvatarType,
                  //                 shape: const CircleBorder(),
                  //                 curve: Curves.bounceIn,
                  //                 duration: const Duration(seconds: 1),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 8),
                  //         Text(
                  //           "Изменить фото",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: CupertinoDynamicColor.withBrightness(
                  //               color: CupertinoTheme.of(context).primaryColor,
                  //               darkColor: CupertinoColors.white,
                  //             ).resolveFrom(context),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  CupertinoFormSection.insetGrouped(
                    clipBehavior: Clip.hardEdge,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoTextFormFieldRow(
                        placeholder: context.t.screenMyProfile.firstName,
                        controller: firstNameController,
                        focusNode: firstNameFocus,
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileCubit>().validateFirstName(value)) {
                            FirstNameValidationError.shotLength => context.t.screenMyProfile.validationFirstNameMaxLength,
                            null => null,
                          };
                          return error;
                        },
                      ),
                      CupertinoTextFormFieldRow(
                        placeholder: context.t.screenMyProfile.lastName,
                        controller: lastNameController,
                        focusNode: lastNameFocus,
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileCubit>().validateFirstName(value)) {
                            FirstNameValidationError.shotLength => context.t.screenMyProfile.validationLastNameMaxLength,
                            null => null,
                          };
                          return error;
                        },
                      ),
                    ],
                  ),

                  // Дата рождения.
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoListTileIcon(
                        title: Text(context.t.screenMyProfile.dateOfBirth),
                        color: Color(0xFFC50CA9),
                        icon: FontAwesomeIcons.cakeCandles,
                        onTab: () async => _pickBirthDate,
                        additionalInfo: Text(context.t.screenMyProfile.add),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.screenMyProfile.aboutMe.toUpperCase()),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoTextField(
                        placeholder: context.t.screenMyProfile.tellUsAboutYourself,
                        maxLines: 1,
                        maxLength: 140,
                        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        // Убираем дефолтную заливку поля (в тёмной теме она чёрная),
                        // чтобы поле сливалось с карточкой секции.
                        decoration: null,
                      ),
                    ],
                  ),

                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoListTileIcon(
                        title: Text(context.t.screenMyProfile.username),
                        color: Color(0xFF3B74BF),
                        icon: FontAwesomeIcons.at,
                        onTab: () async {},
                        additionalInfo: Text(context.t.screenMyProfile.add),
                        isTrailing: true,
                      ),
                      // CupertinoListTileIcon(
                      //   title: const Text("Номер"),
                      //   color: Color(0xFF049A40),
                      //   icon: FontAwesomeIcons.phone,
                      //   onTab: () async => _pickBirthDate,
                      //   additionalInfo: Text("+7 909 160-00-44"),
                      //   isTrailing: true,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
