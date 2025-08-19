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
    final auth = Supabase.instance.client.auth;

    return Scaffold(
      floatingActionButton: const AppSpeedDial(),
      appBar: const MyAppBar(
        text: '클라우드 저장/불러오기',
        weight: FontWeight.bold,
      ),
      body: StreamBuilder<AuthState>(
          stream: auth.onAuthStateChange,
          builder: (context, asyncSnapshot) {
            final session = asyncSnapshot.data?.session ?? auth.currentSession;
            final email = session?.user.email ?? '계정';
            final avatarUrl = session?.user.userMetadata?['avatar_url'];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  session == null
                      ? const UnauthenticatedCard()
                      : AuthenticatedCard(
                          session: session,
                          email: email,
                          avatarUrl: avatarUrl,
                          auth: auth,
                        ),
                  const SizedBox(height: 16),
                  const BackupDateCard(),
                  const SizedBox(height: 16),
                  const StorageCard(),
                ],
              ),
            );
          }),
    );
  }
}
