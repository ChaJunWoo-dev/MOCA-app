import 'package:flutter/material.dart';
import 'package:prob/widgets/common/app_colors.dart';

class ValidForm extends StatelessWidget {
  const ValidForm({
    super.key,
    required this.checker,
    required this.text,
  });

  final bool checker;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Icon(
          checker ? Icons.check_circle_outline_outlined : Icons.cancel_outlined,
          size: 16,
          color: checker ? AppColors.validColor : AppColors.invalidColor,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: checker ? AppColors.validColor : AppColors.invalidColor,
          ),
        ),
      ],
    );
  }
}
