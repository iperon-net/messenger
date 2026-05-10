import 'package:flutter/material.dart';



class IconFrameWidget extends StatelessWidget{
  final double width;
  final double height;
  final Widget icon;
  final Color color;

  const IconFrameWidget({
    this.width = 30,
    this.height = 30,
    this.color = Colors.blue,
    required this.icon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}
