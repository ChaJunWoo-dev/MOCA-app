import 'package:flutter/material.dart';

class ConsumePopup {
  static void consumeDetail(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.lightGreen,
                size: 50,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: msg,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // 굵은 텍스트
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // 확인 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: Colors.blue, // 버튼 배경 파란색
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 확인 버튼 액션
                },
                child: const Text(
                  '닫기',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
