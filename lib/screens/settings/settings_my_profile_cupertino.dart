import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit.dart';
import '../../themes.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
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
  void _pickPhoto() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Фото профиля"),
        actions: [
          CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Сделать фото")),
          CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Выбрать из галереи")),
          CupertinoActionSheetAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: const Text("Удалить фото")),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
      ),
    );
  }

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
              middle: Text(context.t.settings.myProfile),
              leading: CupertinoButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), child: Text(context.t.common.cancel)),
              trailing: CupertinoButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), child: Text(context.t.common.save)),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                // Аватарка с кнопкой выбора фото.
                Center(
                  child: GestureDetector(
                    onTap: _pickPhoto,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 96,
                              height: 96,
                              child: AnimatedBoringAvatar(
                                name: state.boringAvatarHash,
                                type: state.boringAvatarType,
                                shape: const CircleBorder(),
                                curve: Curves.bounceIn,
                                duration: const Duration(seconds: 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Изменить фото",
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoTheme.of(context).primaryColor,
                              darkColor: CupertinoColors.white,
                            ).resolveFrom(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoFormSection.insetGrouped(
                  clipBehavior: Clip.hardEdge,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  children: [
                    CupertinoTextFormFieldRow(placeholder: "Имя"),
                    CupertinoTextFormFieldRow(placeholder: "Фамилия"),
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
                      title: const Text("Дата рождения"),
                      color: Color(0xFFC50CA9),
                      icon: FontAwesomeIcons.cakeCandles,
                      onTab: () async => _pickBirthDate,
                      additionalInfo: Text("Указать"),
                    ),
                  ],
                ),

                // О себе.
                CupertinoFormSection.insetGrouped(
                  header: const Text("О СЕБЕ"),
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  children: const [
                    CupertinoTextField(
                      placeholder: "Расскажите о себе",
                      maxLines: 1,
                      maxLength: 140,
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                      // Убираем дефолтную заливку поля (в тёмной теме она чёрная),
                      // чтобы поле сливалось с карточкой секции.
                      decoration: null,
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
                      title: const Text("Имя пользователя"),
                      color: Color(0xFF3B74BF),
                      icon: FontAwesomeIcons.at,
                      onTab: () async {},
                      additionalInfo: Text("Указать"),
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
        );
      },
    );
  }
}
