import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class UnauthenticatedCard extends StatelessWidget {
  const UnauthenticatedCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.cloud_outlined,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '백업을 시작해볼까요?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Google 로그인 후 클라우드에 안전하게 저장',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 14),
            SupaSocialsAuth(
              socialProviders: const [OAuthProvider.google],
              colored: true,
              showSuccessSnackBar: false,
              redirectUrl: 'myapp://login-callback',
              onSuccess: (s) {},
              onError: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그인에 실패했어요')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
