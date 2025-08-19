import 'package:flutter/material.dart';
import 'package:prob/widgets/backup_screen/storage_card.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:storage_space/storage_space.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: AppSpeedDial(),
      appBar: MyAppBar(
        text: '클라우드 저장/불러오기',
        weight: FontWeight.bold,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AuthHeroSection(),
            SizedBox(height: 16),
            _InfoCard(title: '마지막 백업', content: '2024년 4월 24일 20:15'),
            SizedBox(height: 16),
            StorageCard(),
          ],
        ),
      ),
    );
  }
}

class _AuthHeroSection extends StatelessWidget {
  const _AuthHeroSection();

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, snap) {
        final session = snap.data?.session ?? auth.currentSession;

        if (session == null) {
          return Card(
            elevation: 0,
            color: const Color(0xFFF2F4F7),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
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
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 20,
                        color: Colors.black54,
                      ),
                      Text(
                        '백업에는 반드시 로그인이 필요해요',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        final email = session.user.email ?? '계정';
        return Card(
          elevation: 0,
          color: const Color(0xFFF2F4F7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.cloud_done_rounded, size: 28),
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
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.content});
  final String title, content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          Text(content),
        ]),
      ),
    );
  }
}
