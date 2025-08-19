import 'package:flutter/material.dart';
import 'package:prob/widgets/backup_screen/authenticated_card.dart';
import 'package:prob/widgets/backup_screen/backup_date_card.dart';
import 'package:prob/widgets/backup_screen/storage_card.dart';
import 'package:prob/widgets/backup_screen/unauthenticated_card.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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
            BackupDateCard(),
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
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? auth.currentSession;

        if (session == null) {
          return const UnauthenticatedCard();
        }

        final email = session.user.email ?? '계정';
        final avatarUrl = session.user.userMetadata?['avatar_url'];

        return AuthenticatedCard(
          session: session,
          email: email,
          avatarUrl: avatarUrl,
          auth: auth,
        );
      },
    );
  }
}
