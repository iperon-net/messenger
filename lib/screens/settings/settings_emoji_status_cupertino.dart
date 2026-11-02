import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'settings_emoji_status_common.dart';

class SettingsEmojiStatusCupertino extends StatefulWidget {
  const SettingsEmojiStatusCupertino({super.key});

  @override
  State<SettingsEmojiStatusCupertino> createState() => _SettingsEmojiStatusCupertinoState();
}

class _SettingsEmojiStatusCupertinoState extends State<SettingsEmojiStatusCupertino> {
  late String _emoji;
  late Duration? _duration;
  late bool _doNotDisturb;

  @override
  void initState() {
    super.initState();
    final status = context.read<SettingsMyProfileCubit>().state.emojiStatus;
    _emoji = status.active ? status.emoji : emojiStatusChoices.first;
    _duration = status.active && status.expiresAt != null ? const Duration(hours: 4) : null;
    _doNotDisturb = status.mutes;
  }

  Future<void> _save({bool remove = false}) async {
    final status = remove
        ? const models.EmojiStatus()
        : models.EmojiStatus(
            emoji: _emoji,
            expiresAt: _duration == null ? null : DateTime.now().add(_duration!),
            doNotDisturb: _doNotDisturb,
          );
    if (await context.read<SettingsMyProfileCubit>().setEmojiStatus(status) && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenMyProfile;
    return BlocBuilder<SettingsMyProfileCubit, SettingsMyProfileState>(
      builder: (context, state) => CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.groupedBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            middle: Text(t.emojiStatus),
            previousPageTitle: '',
            trailing: NavBarButtonCupertino(
              NavBarAction.done,
              label: context.t.common.save,
              loading: state.networkStatus == Status.loading,
              onPressed: _save,
            ),
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t.setEmojiStatus, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final emoji in emojiStatusChoices)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() => _emoji = emoji),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: emoji == _emoji ? CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.18) : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 30)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(t.emojiStatusDuration, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                children: [
                  for (final item in emojiStatusDurations(context.t))
                    CupertinoListTile(
                      title: Text(item.title),
                      trailing: item.duration == _duration ? const Icon(CupertinoIcons.check_mark) : null,
                      onTap: () => setState(() {
                        _duration = item.duration;
                        if (_duration == null) _doNotDisturb = false;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                footer: Padding(padding: const EdgeInsets.only(top: 8), child: Text(t.doNotDisturbHint)),
                children: [
                  CupertinoListTile(
                    title: Text(t.doNotDisturb),
                    trailing: CupertinoSwitch(
                      value: _doNotDisturb,
                      onChanged: _duration == null ? null : (value) => setState(() => _doNotDisturb = value),
                    ),
                  ),
                ],
              ),
              if (state.emojiStatus.active) ...[
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: state.networkStatus == Status.loading ? null : () => _save(remove: true),
                  child: Text(t.removeEmojiStatus, style: const TextStyle(color: CupertinoColors.systemRed)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
