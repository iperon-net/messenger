import 'package:flutter/material.dart';


Widget dividerText({required String text}) {
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
