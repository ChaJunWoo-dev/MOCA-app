import 'package:flutter/material.dart';

class TypeSelectBox extends StatefulWidget {
  final ValueChanged<String> onTypeChanged;

  const TypeSelectBox({
    super.key,
    required this.onTypeChanged,
  });

  @override
  State<TypeSelectBox> createState() => _TypeSelectBoxState();
}

class _TypeSelectBoxState extends State<TypeSelectBox> {
  String selected = '지출';

  void _select(String type) {
    setState(() => selected = type);
    widget.onTypeChanged(type);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('지출', selected == '지출', () => _select('지출')),
        const SizedBox(width: 15),
        _chip('이체', selected == '이체', () => _select('이체')),
      ],
    );
  }

  Widget _chip(String label, bool on, VoidCallback onSelect) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(color: on ? Colors.blue : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: on ? Colors.blue : Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
