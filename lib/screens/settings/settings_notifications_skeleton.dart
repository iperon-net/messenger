import 'package:material_ui/material_ui.dart';

import '../../components.dart';

class SettingsNotificationsSkeleton extends StatelessWidget {
  final bool scope;

  const SettingsNotificationsSkeleton({this.scope = false, super.key});

  Widget _header(double width) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
    child: Container(width: width, height: 13, decoration: _shape(6)),
  );

  Widget _row({bool chevron = false}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
    child: Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: chevron ? 0.42 : 0.62,
              child: Container(height: 15, decoration: _shape(7)),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Container(width: chevron ? 8 : 46, height: chevron ? 14 : 27, decoration: _shape(chevron ? 4 : 14)),
      ],
    ),
  );

  Widget _section({required int rows, bool chevron = false}) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        for (var index = 0; index < rows; index++) ...[
          if (index > 0) const Divider(height: 1, indent: 16, endIndent: 16),
          _row(chevron: chevron),
        ],
      ],
    ),
  );

  static BoxDecoration _shape(double radius) => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surfaceContainerLow,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: scope
            ? [const SizedBox(height: 16), _section(rows: 3)]
            : [_header(170), _section(rows: 3, chevron: true), _header(100), _section(rows: 2), _header(90), _section(rows: 2)],
      ),
    );
  }
}
