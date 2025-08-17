import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AmountInputField extends StatefulWidget {
  final Color mainColor;
  final TextEditingController controller;

  const AmountInputField({
    super.key,
    required this.mainColor,
    required this.controller,
  });

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyInputFormatter(
          thousandSeparator: ThousandSeparator.Comma,
          mantissaLength: 0,
          trailingSymbol: '원',
        )
      ],
      decoration: InputDecoration(
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey.shade400,
                ),
                onPressed: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
              )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.mainColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.mainColor, width: 2),
        ),
      ),
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
