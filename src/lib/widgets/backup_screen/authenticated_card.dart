import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/error/backup_error.dart';
import 'package:prob/providers/backup/backup_write_provider.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthenticatedCard extends ConsumerWidget {
  final Session? session;
  final String email, avatarUrl;
  final GoTrueClient auth;
  final void Function(String?) onBackupUpdated;

  const AuthenticatedCard({
    super.key,
    required this.session,
    required this.email,
    required this.avatarUrl,
    required this.auth,
    required this.onBackupUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> uploadStorage() async {
      final userId = session?.user.id;

      if (userId == null) {
        if (!context.mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: '로그인 후 이용해 주세요'),
        );

        return;
      }

      try {
        await ref.read(backupWriteProvider.notifier).upload(userId);
        onBackupUpdated(userId);

        if (!context.mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(message: '클라우드 저장 성공'),
        );
      } on BackupError catch (err) {
        showTopSnackBar(Overlay.of(context),
            CustomSnackBar.error(message: backupErrorMessage(err)));
      } catch (_) {
        showTopSnackBar(Overlay.of(context),
            const CustomSnackBar.error(message: '알 수 없는 오류'));
      }
    }

    Future<void> downloadStorage() async {
      final userId = session?.user.id;

      if (userId == null) {
        if (!context.mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: '로그인 후 이용해 주세요'),
        );

        return;
      }

      try {
        await ref.read(backupWriteProvider.notifier).restore(userId);

        if (!context.mounted) return;
        showTopSnackBar(Overlay.of(context),
            const CustomSnackBar.success(message: '데이터 복구 완료'));
      } on BackupError catch (err) {
        if (!context.mounted) return;

        showTopSnackBar(Overlay.of(context),
            CustomSnackBar.error(message: backupErrorMessage(err)));
      } catch (_) {
        if (!context.mounted) return;

        showTopSnackBar(Overlay.of(context),
            const CustomSnackBar.error(message: '데이터 가져오기 실패'));
      }
    }

    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            Row(
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
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.error(message: '로그아웃 완료'),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('로그아웃'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '클라우드에 저장',
                    onPressed: uploadStorage,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AppButton(
                    text: '데이터 가져오기',
                    onPressed: downloadStorage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
