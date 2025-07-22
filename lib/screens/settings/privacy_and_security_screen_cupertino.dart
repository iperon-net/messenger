import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/translations.g.dart';
import 'privacy_and_security_cubit.dart';

class PrivacyAndSecurityScreenCupertino extends StatefulWidget {
  const PrivacyAndSecurityScreenCupertino({super.key});

  @override
  State<PrivacyAndSecurityScreenCupertino> createState() => _PrivacyAndSecurityScreenCupertino();
}

class _PrivacyAndSecurityScreenCupertino extends State<PrivacyAndSecurityScreenCupertino> {

  @override
  void initState() {
    context.read<PrivacyAndSecurityCubit>().initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        previousPageTitle: t.settings.language.back,
        middle: Text(context.t.settings.privacyAndSecurity.privacyAndSecurity),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<PrivacyAndSecurityCubit, PrivacyAndSecurityState>(
            builder: (context, state) {
              return Column(
                children: [
                  CupertinoFormSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.lock_shield),
                        title: Text(context.t.settings.privacyAndSecurity.twoStepVerification, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                      ),
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.lock),
                        title: Text(context.t.settings.privacyAndSecurity.passcode.passcode, style: TextStyle(fontSize: 15),),
                        trailing: CupertinoListTileChevron(),
                        onTap: () => context.goNamed("settings_privacy_security_passcode"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
