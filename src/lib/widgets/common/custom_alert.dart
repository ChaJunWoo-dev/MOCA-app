import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prob/provider/loading_provider.dart';
import 'package:prob/widgets/sign_up_page/reset.dart';
import 'package:provider/provider.dart';

class MyAlert {
  static void successAccentShow(
      BuildContext context, Map<dynamic, dynamic> msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
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
                  text: msg['main'][0],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // 굵은 텍스트
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: msg['main'][1],
                      style: const TextStyle(
                        color: Colors.blue, // 파란색 텍스트
                      ),
                    ),
                    TextSpan(text: msg['main'][2]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                msg['sub'],
                style: const TextStyle(
                  color: Colors.grey, // 설명 텍스트 회색
                  fontSize: 14.0,
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
                  '확인',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void failAccentShow(BuildContext context, Map<dynamic, dynamic> msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: msg['main'][0],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // 굵은 텍스트
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: msg['main'][1],
                      style: const TextStyle(
                        color: Colors.red, // 파란색 텍스트
                      ),
                    ),
                    TextSpan(text: msg['main'][2]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                msg['sub'],
                style: const TextStyle(
                  color: Colors.grey, // 설명 텍스트 회색
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20),
              // 확인 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: Colors.red, // 버튼 배경 파란색
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 확인 버튼 액션
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void successShow(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
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
                  '확인',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void failShow(BuildContext context, String msg, String? path) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
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
                  backgroundColor: Colors.red, // 버튼 배경 파란색
                ),
                onPressed: () {
                  if (path == null) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushReplacementNamed(context, path);
                    context.read<MainLoadingProvider>().setError(null);
                  }
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void closeConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sentiment_dissatisfied_rounded,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: "회원가입을",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " 중단",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(text: "하시겠어요?"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "지금까지 진행된 내용은 모두 초기화됩니다",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20),
              // 확인 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Reset.resetproviders(context);
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void fieldNullMsg(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: '비어있는 필드가 있어요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // 굵은 텍스트
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '모든 필드를 입력해주세요',
                style: TextStyle(
                  color: Colors.grey, // 설명 텍스트 회색
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20),
              // 확인 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: Colors.red, // 버튼 배경 빨간색
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 확인 버튼 액션
                },
                child: const Text(
                  '확인',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 흰색
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> yesOrNoAlert(
      BuildContext context, IconData icon, String text, String subText) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.blueGrey,
                size: 50,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20),
              // 확인 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () {
                      result = true;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return result;
  }
}

class CustomAlert {
  static void show(BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('알림', style: TextStyle(color: color)),
          content: Text(message, style: TextStyle(color: color)),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: color)),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  static Future<void> signup(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}

class IOSAlert {
  static void show(BuildContext context, String message, Color color) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // iOS 스타일의 title을 추가하려면 이 부분을 활성화하면 됩니다.
          title: Text('알림', style: TextStyle(color: color)),
          content: Text(
            message,
            style: TextStyle(color: color),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                '확인',
                style: TextStyle(color: color),
              ),
            ),
          ],
        );
      },
    );
  }
}
