import 'package:flutter/material.dart';

class InputRow extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool showIcon;

  const InputRow({
    super.key,
    required this.title,
    required this.widget,
    required this.showIcon,
  });

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30;
    const double labelWidth = 60;

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                SizedBox(
                  width: labelWidth,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: widget,
                ),
                if (showIcon)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade500,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
        Divider(
          indent: horizontalPadding,
          endIndent: horizontalPadding,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
