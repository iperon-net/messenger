import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

part 'language_cubit.freezed.dart';
part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());
  final logger = getIt.get<Logger>();

  Widget trailingIcon(BuildContext context, {required AppLocale language}) {
    if (LocaleSettings.currentLocale == language) {
      return Icon(
        CupertinoIcons.check_mark_circled_solid,
        color: CupertinoTheme.of(context).primaryColor,
      );
    }
    return Container();
  }

}
