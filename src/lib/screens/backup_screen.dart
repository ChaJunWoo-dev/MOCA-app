import 'package:flutter/material.dart';
import 'package:prob/widgets/backup_screen/authenticated_card.dart';
import 'package:prob/widgets/backup_screen/backup_date_card.dart';
import 'package:prob/widgets/backup_screen/storage_card.dart';
import 'package:prob/widgets/backup_screen/unauthenticated_card.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  DateTime? _lastBackupDate;

  @override
  void initState() {
    super.initState();

    final userId = Supabase.instance.client.auth.currentUser?.id;
    _getLastBackupDate(userId);
  }

  Future<void> _getLastBackupDate(String? userId) async {
    if (userId == null) return;

    final backupData = await Supabase.instance.client.storage
        .from('backups')
        .list(path: userId);

    if (backupData.isEmpty) return;

    setState(
      () => _lastBackupDate = DateTime.parse(backupData.first.updatedAt!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;

    return Scaffold(
      floatingActionButton: const AppSpeedDial(),
      appBar: const MyAppBar(
        text: '클라우드 저장/가져오기',
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
                          onBackupUpdated: _getLastBackupDate,
                        ),
                  const SizedBox(height: 16),
                  BackupDateCard(
                      session: session, lastBackupDate: _lastBackupDate),
                  const SizedBox(height: 16),
                  const StorageCard(),
                ],
              ),
            );
          }),
    );
  }
}
