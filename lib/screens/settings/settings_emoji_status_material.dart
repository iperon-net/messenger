import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'settings_emoji_status_common.dart';

class SettingsEmojiStatusMaterial extends StatefulWidget {
  const SettingsEmojiStatusMaterial({super.key});

  @override
  State<SettingsEmojiStatusMaterial> createState() => _SettingsEmojiStatusMaterialState();
}

class _SettingsEmojiStatusMaterialState extends State<SettingsEmojiStatusMaterial> {
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
        return Scaffold(
          appBar: AppBar(
            title: Text(t.emojiStatus),
            actions: [
              state.networkStatus == Status.loading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : IconButton(tooltip: context.t.common.save, onPressed: _save, icon: const Icon(Icons.check)),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                EmojiStatusPreview(emoji: _emoji),
                const SizedBox(height: 12),
                TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: t.emojiStatusSearch,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final category in EmojiStatusCategory.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(emojiStatusCategoryTitle(context.t, category)),
                            selected: category == _category,
                            onSelected: (_) => setState(() => _category = category),
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
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => setState(() => _emoji = emoji),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: emoji == _emoji ? Theme.of(context).colorScheme.primaryContainer : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(emoji, style: const TextStyle(fontSize: 30)),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                Text(t.emojiStatusDuration, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: RadioGroup<Duration?>(
                    groupValue: _duration,
                    onChanged: (value) => setState(() {
                      _duration = value;
                      if (_duration == null) _doNotDisturb = false;
                    }),
                    child: Column(
                      children: [
                        for (final item in emojiStatusDurations(context.t))
                          RadioListTile<Duration?>(value: item.duration, title: Text(item.title)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: SwitchListTile(
                    value: _doNotDisturb,
                    onChanged: _duration == null ? null : (value) => setState(() => _doNotDisturb = value),
                    title: Text(t.doNotDisturb),
                    subtitle: Text(t.doNotDisturbHint),
                  ),
                ),
                if (state.emojiStatus.active)
                  TextButton(
                    onPressed: state.networkStatus == Status.loading ? null : () => _save(remove: true),
                    child: Text(t.removeEmojiStatus, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
