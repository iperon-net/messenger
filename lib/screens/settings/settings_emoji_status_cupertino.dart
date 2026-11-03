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
  final _search = TextEditingController();
  EmojiStatusCategory _category = EmojiStatusCategory.popular;
  late bool _statusRestored;

  @override
  void initState() {
    super.initState();
    final state = context.read<SettingsMyProfileCubit>().state;
    _statusRestored = state.status == Status.success;
    _restoreStatus(state.emojiStatus);
    _search.addListener(() => setState(() {}));
  }

  void _restoreStatus(models.EmojiStatus status) {
    _emoji = status.active ? status.emoji : emojiStatusChoices.first;
    _duration = status.active && status.expiresAt != null ? const Duration(hours: 4) : null;
    _doNotDisturb = status.mutes;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
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
    final items = emojiStatusItems(_category, _search.text);
    return BlocBuilder<SettingsMyProfileCubit, SettingsMyProfileState>(
      builder: (context, state) {
        if (!_statusRestored && state.status == Status.success) {
          _statusRestored = true;
          _restoreStatus(state.emojiStatus);
        }
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
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
                EmojiStatusPreview(emoji: _emoji),
                const SizedBox(height: 12),
                CupertinoSearchTextField(controller: _search, placeholder: t.emojiStatusSearch),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final category in EmojiStatusCategory.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CupertinoButton(
                            sizeStyle: CupertinoButtonSize.small,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            color: category == _category ? CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.18) : null,
                            onPressed: () => setState(() => _category = category),
                            child: Text(
                              emojiStatusCategoryTitle(context.t, category),
                              style: TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: category == _category
                                    ? CupertinoTheme.of(context).primaryColor
                                    : CupertinoColors.label.resolveFrom(context),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 280,
                  child: items.isEmpty
                      ? Center(child: Text(t.emojiStatusNotFound))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final emoji = items[index].toUnicodeEmoji();
                            return CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => setState(() => _emoji = emoji),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: emoji == _emoji ? CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.18) : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(emoji, style: const TextStyle(fontSize: 30)),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
                Text(
                  t.emojiStatusDuration,
                  style: const TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8),
                CupertinoListSection.insetGrouped(
                  margin: EdgeInsets.zero,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
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
                const SizedBox(height: 20),
                CupertinoListSection.insetGrouped(
                  margin: EdgeInsets.zero,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      t.doNotDisturbHint,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                    ),
                  ),
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
        );
      },
    );
  }
}
