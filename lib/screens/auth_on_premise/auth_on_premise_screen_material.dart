import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'auth_on_premise_cubit.dart';

class AuthOnPremiseMaterialScreen extends StatefulWidget {
  const AuthOnPremiseMaterialScreen({super.key});

  @override
  State<AuthOnPremiseMaterialScreen> createState() => _AuthOnPremiseMaterialScreen();
}

class _AuthOnPremiseMaterialScreen extends State<AuthOnPremiseMaterialScreen> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Form(
        key: context.read<AuthOnPremiseCubit>().formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                spacing: 30,
                children: [
                  SizedBox(height: 25, width: double.infinity),

                  InkWell(
                    child: SvgPicture.asset(Theme.of(context).brightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                    onDoubleTap: () => context.read<AuthOnPremiseCubit>().switchDebugListServers(),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl,
                    validator: (value) => context.read<AuthOnPremiseCubit>().validatorOrganizationServerUrl(context, value),
                    decoration: InputDecoration(
                      errorText: context.watch<AuthOnPremiseCubit>().state.errorFieldOrganizationServerUrl.isNotEmpty ?
                        context.read<AuthOnPremiseCubit>().state.errorFieldOrganizationServerUrl : null,
                      labelText: context.t.organizationServerUrl,
                      errorMaxLines: 2,
                      helperText: context.t.organizationServerUrlHelper,
                      helperMaxLines: 2,
                    ),
                    onEditingComplete: () async => context.read<AuthOnPremiseCubit>().validator(context),
                    keyboardType: TextInputType.url,
                    autofillHints: const [AutofillHints.url],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async => context.read<AuthOnPremiseCubit>().validator(context),
                      child: Text(context.t.next),
                    ),
                  ),

                  if (kDebugMode && context.read<AuthOnPremiseCubit>().state.debugListServers) ...[
                    Column(
                      spacing: 10,
                      children: [
                        InkWell(
                          child: Text("Local server"),
                          onTap: () => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "https://localhost.iperon.net:50051",
                        ),
                        InkWell(
                          child: Text("Testing server"),
                          onTap: () => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "https://staging.iperon.net",
                        ),
                        InkWell(
                          child: Text("Invalid server"),
                          onTap: () => context.read<AuthOnPremiseCubit>().textControllerOrganizationServerUrl.text = "http://invalid.com",
                        ),
                        // Text(context.read<AuthOnPremiseCubit>().state.errorFieldOrganizationServerUrl.isNotEmpty.toString()),
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
