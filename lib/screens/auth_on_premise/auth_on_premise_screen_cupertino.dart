import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'auth_on_premise_cubit.dart';

class AuthOnPremiseCupertinoScreen extends StatefulWidget {
  const AuthOnPremiseCupertinoScreen({super.key});

  @override
  State<AuthOnPremiseCupertinoScreen> createState() => _AuthOnPremiseCupertinoScreen();
}

class _AuthOnPremiseCupertinoScreen extends State<AuthOnPremiseCupertinoScreen> {
  final logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Form(
          key: context.read<AuthOnPremiseCubit>().formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: CupertinoTheme.brightnessOf(context) == Brightness.light ? SvgPicture.asset('assets/images/logo_light.svg') : SvgPicture.asset('assets/images/logo_dark.svg'),
                      onDoubleTap: () => context.read<AuthOnPremiseCubit>().switchDebugListServers(),
                    ),

                    const SizedBox(height: 30),

                    if (context.watch<AuthOnPremiseCubit>().state.errorFieldOrganizationServerUrl.isNotEmpty) ...[
                      Text(
                        context.read<AuthOnPremiseCubit>().state.errorFieldOrganizationServerUrl,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                    ],

                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const CupertinoDynamicColor.withBrightness(
                              color: Colors.black12,
                              darkColor: Colors.white24,
                            ).resolveFrom(context),
                          ),
                          bottom: BorderSide(
                            color: const CupertinoDynamicColor.withBrightness(
                               color: Colors.black12,
                               darkColor: Colors.white24,
                            ).resolveFrom(context),
                          ),
                        ),
                      ),
                      child: CupertinoTextFormFieldRow(
                        autocorrect: true,
                        autofocus: true,
                        controller: context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl,
                        keyboardType: TextInputType.url,
                        autofillHints: const [AutofillHints.url],
                        placeholder: context.t.organizationServerUrl,
                        textInputAction: TextInputAction.next,
                        prefix: FaIcon(FontAwesomeIcons.satelliteDish),
                        onEditingComplete: () async => context.read<AuthOnPremiseCubit>().validator(context),
                        validator: (value) => context.read<AuthOnPremiseCubit>().validatorOrganizationServerUrl(context, value),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton.filled(
                        onPressed: () async => await context.read<AuthOnPremiseCubit>().validator(context),
                        child: Text(context.t.next),
                      ),
                    ),

                    if (kDebugMode && context.read<AuthOnPremiseCubit>().state.debugListServers ) ...[
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          CupertinoButton(
                            onPressed: () async => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "https://localhost.iperon.net:50051",
                            child: Text("Local server"),
                          ),
                          CupertinoButton(
                            onPressed: () async => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "https://staging.iperon.net",
                            child: Text("Testing server"),
                          ),
                          CupertinoButton(
                            onPressed: () async => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "http://invalid.com",
                            child: Text("Invalid server"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
