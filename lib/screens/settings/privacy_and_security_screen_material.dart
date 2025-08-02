import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/widget_wrapper/widget_wrapper.dart';
import '../../i18n/translations.g.dart';

class PrivacyAndSecurityScreenMaterial extends StatefulWidget {
  const PrivacyAndSecurityScreenMaterial({super.key});

  @override
  State<PrivacyAndSecurityScreenMaterial> createState() => _PrivacyAndSecurityScreenMaterial();
}

class _PrivacyAndSecurityScreenMaterial extends State<PrivacyAndSecurityScreenMaterial> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.settings.privacyAndSecurity.privacyAndSecurity),
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  ListTile(
                      title: Text(
                        context.t.settings.privacyAndSecurity.privacyAndSecurity,
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                            fontStyle: FontStyle.normal
                        ),
                      )
                  ),
                  ListTile(
                    title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
                    leading: Icon(Icons.lock_outline),
                    onTap: () => context.goNamed("settings_privacy_security_passcode"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
