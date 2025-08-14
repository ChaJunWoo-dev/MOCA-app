import 'package:flutter/material.dart';

class HistoryControlBtn extends StatelessWidget {
  final String label;
  final VoidCallback method;

  const HistoryControlBtn({
    super.key,
    required this.label,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 50,
      child: OutlinedButton(
        onPressed: method,
        style: ButtonStyle(
            backgroundColor:
                const WidgetStatePropertyAll<Color>(Color(0xffFFEECC)),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
            ),
            side: const WidgetStatePropertyAll<BorderSide>(BorderSide.none),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
