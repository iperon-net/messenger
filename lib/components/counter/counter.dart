import 'package:flutter/cupertino.dart';

//ignore: must_be_immutable
class CounterComponent extends StatelessWidget {
  int count = 0;
  bool colorIsActive = false;
  CounterComponent({super.key, required this.count, this.colorIsActive = false});


  @override
  Widget build(BuildContext context) {
    String countText = "";
    if (count >= 1000) {
      countText = "${((count / 1000 * 100).round() / 100).toString().toString()}к";
    } else {
      countText = count.toString();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          // color: colorIsActive ? CupertinoTheme.of(context).primaryColor : CupertinoTheme.of(context).scaffoldBackgroundColor,
          width: 1,
          style: BorderStyle.none,
        ),
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        // color: CupertinoTheme.of(context).primaryColor,
        borderRadius: count > 99 ? BorderRadius.circular(12) : null,
        shape: count > 99 ? BoxShape.rectangle: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Text(
          countText,
          style: TextStyle(
            fontSize: 12.0,
            // color: CupertinoTheme.of(context).primaryContrastingColor,
          ),
        ),
      ),
    );
  }
}
