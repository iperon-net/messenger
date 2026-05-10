import 'package:flutter/material.dart';

class DividerTextWidget extends StatelessWidget{
  final String text;

  const DividerTextWidget({
    required this.text,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
