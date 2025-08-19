import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthenticatedCard extends StatelessWidget {
  final Session? session;
  final String email, avatarUrl;
  final GoTrueClient auth;

  const AuthenticatedCard({
    super.key,
    required this.session,
    required this.email,
    required this.avatarUrl,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  (avatarUrl.isNotEmpty) ? NetworkImage(avatarUrl) : null,
              child: (avatarUrl.isEmpty)
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            TextButton.icon(
              onPressed: () async {
                await auth.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그아웃 완료')),
                  );
                }
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
