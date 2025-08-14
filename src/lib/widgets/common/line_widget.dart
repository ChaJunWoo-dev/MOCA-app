import 'package:flutter/cupertino.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({
    super.key,
    required this.color,
    required this.height,
    required this.width,
  });
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}
